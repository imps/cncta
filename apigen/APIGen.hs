{-# LANGUAGE DeriveDataTypeable #-}
import Data.List (intercalate)
import Data.Maybe (catMaybes)
import System.Console.CmdArgs.Implicit
import Language.JavaScript.Parser (parseFile, JSNode(..), Node(..))

data APIGen = PrintClasses { inputFile :: FilePath }
            | PrintFunctions { inputFile :: FilePath }
            deriving (Show, Data, Typeable)

printClasses :: APIGen
printClasses = PrintClasses
    { inputFile = def &= typFile &= argPos 0
    } &= help "Print out all classes"

printFunctions :: APIGen
printFunctions = PrintFunctions
    { inputFile = def &= typFile &= argPos 0
    } &= help "Print out all functions"

process :: APIGen -> IO ()
process PrintClasses{inputFile = i} = showJS i
process PrintFunctions{inputFile = i} = showJS i

allModes :: APIGen
allModes = (modes [printFunctions &= auto, printClasses])

showJS :: FilePath -> IO ()
showJS fp = do
    jsnode <- parseFile fp
    mapM_ putStrLn $ traverseJS jsnode

traverseJS :: JSNode -> [String]
traverseJS = extract . extractNode

-- | Extract contents of a node
contains :: [JSNode] -> [String]
contains = concat . map traverseJS

-- | Contains without terminals
containsDeep :: [JSNode] -> [String]
containsDeep = contains . filter (not . isTerminal)
  where isTerminal (NT _ _ _) = True
        isTerminal _          = False

-- | Extract all identifiers and literals within a list of 'JSNode's
extractNames :: [JSNode] -> [String]
extractNames = catMaybes . map (getName . extractNode)
  where getName :: Node -> Maybe String
        getName (JSIdentifier    n) = Just n
        getName (JSLiteral       n) = Just n
        getName (JSMemberDot f _ n) = getDotName f n
        getName _                   = Nothing

        getDotName f n = Just . intercalate "." . extractNames $ f ++ [n]

-- | Check whether a 'JSNode' is a function
isFun :: JSNode -> Bool
isFun = check . extractNode
  where check :: Node -> Bool
        check (JSFunction           _ _ _ _ _ _) = True
        check (JSFunctionExpression _ _ _ _ _ _) = True
        check _                                  = False

-- | Check if a 'JSNode' matches an operator
isOp :: String -> JSNode -> Bool
isOp op = check . extractNode
  where check :: Node -> Bool
        check (JSOperator n) | op `elem` extractNames [n] = True
                             | otherwise                  = False
        check _              = False

-- | Check whether 'JSNode' contains an assignment operator
isEq :: JSNode -> Bool
isEq = isOp "="

-- | Handle an expression container
handleExpr :: [JSNode] -> [String]
handleExpr [var, o, n] | isFun n && isEq o = extractNames [var]
handleExpr n = contains n

-- | Extract name for a function and traverse further
extractFun :: [JSNode] -- ^ Function name(s)
           -> JSNode   -- ^ Function container
           -> [String]
extractFun n = (++) (extractNames n) . traverseJS

-- | Generic extractor, traversing the whole AST
extract :: Node -> [String]
extract (JSExpression expr)                     = handleExpr expr
extract (JSExpressionParen   _ expr _)          = traverseJS expr
extract (JSExpressionPostfix _ expr _)          = contains expr
extract (JSFunctionExpression _ ns _ _ _ block) = extractFun ns  block
extract (JSFunction           _ n  _ _ _ block) = extractFun [n] block
extract (JSBlock _ stmts _)                     = containsDeep stmts
extract (JSIf _ _ _ _ stmts _)                  = containsDeep stmts
extract (JSSourceElementsTop stmts)             = containsDeep stmts
extract _                                       = []

-- | Simply extract a node from a 'JSNode'
extractNode :: JSNode -> Node
extractNode (NN n    ) = n
extractNode (NT n _ _) = n

main :: IO ()
main = process =<< cmdArgs allModes
