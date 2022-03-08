module Main where

import Test.HUnit
import Lib3
import Parser
import Data.Either
import JsonLike

--________________________________________________________________________________
--                            PARSER TESTS
--________________________________________________________________________________

accept1  = TestCase (assertEqual "{\"bomb\":null,\"surrounding\":{\"bombermans\":{\"head\":[1,1],\"tail\":{\"head\":null,\"tail\":null}},\"bricks\":{\"head\":[8,7],\"tail\":{\"head\":[8,3],\"tail\":{\"head\":[8,1],\"tail\":{\"head\":[6,7],\"tail\":{\"head\":[6,5],\"tail\":{\"head\":[5,8],\"tail\":{\"head\":[5,4],\"tail\":{\"head\":[3,6],\"tail\":{\"head\":[3,4],\"tail\":{\"head\":[2,3],\"tail\":{\"head\":[2,1],\"tail\":{\"head\":[1,8],\"tail\":{\"head\":[1,7],\"tail\":{\"head\":[1,6],\"tail\":{\"head\":null,\"tail\":null}}}}}}}}}}}}}}},\"gates\":{\"head\":null,\"tail\":null},\"ghosts\":{\"head\":null,\"tail\":null},\"wall\":{\"head\":[8,8],\"tail\":{\"head\":[8,6],\"tail\":{\"head\":[8,4],\"tail\":{\"head\":[8,2],\"tail\":{\"head\":[8,0],\"tail\":{\"head\":[7,0],\"tail\":{\"head\":[6,8],\"tail\":{\"head\":[6,6],\"tail\":{\"head\":[6,4],\"tail\":{\"head\":[6,2],\"tail\":{\"head\":[6,0],\"tail\":{\"head\":[5,0],\"tail\":{\"head\":[4,8],\"tail\":{\"head\":[4,6],\"tail\":{\"head\":[4,4],\"tail\":{\"head\":[4,2],\"tail\":{\"head\":[4,0],\"tail\":{\"head\":[3,0],\"tail\":{\"head\":[2,8],\"tail\":{\"head\":[2,6],\"tail\":{\"head\":[2,4],\"tail\":{\"head\":[2,2],\"tail\":{\"head\":[2,0],\"tail\":{\"head\":[1,0],\"tail\":{\"head\":[0,8],\"tail\":{\"head\":[0,7],\"tail\":{\"head\":[0,6],\"tail\":{\"head\":[0,5],\"tail\":{\"head\":[0,4],\"tail\":{\"head\":[0,3],\"tail\":{\"head\":[0,2],\"tail\":{\"head\":[0,1],\"tail\":{\"head\":[0,0],\"tail\":{\"head\":null,\"tail\":null}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}"
                     True (isRight (parseJson "{\"bomb\":null,\"surrounding\":{\"bombermans\":{\"head\":[1,1],\"tail\":{\"head\":null,\"tail\":null}},\"bricks\":{\"head\":[8,7],\"tail\":{\"head\":[8,3],\"tail\":{\"head\":[8,1],\"tail\":{\"head\":[6,7],\"tail\":{\"head\":[6,5],\"tail\":{\"head\":[5,8],\"tail\":{\"head\":[5,4],\"tail\":{\"head\":[3,6],\"tail\":{\"head\":[3,4],\"tail\":{\"head\":[2,3],\"tail\":{\"head\":[2,1],\"tail\":{\"head\":[1,8],\"tail\":{\"head\":[1,7],\"tail\":{\"head\":[1,6],\"tail\":{\"head\":null,\"tail\":null}}}}}}}}}}}}}}},\"gates\":{\"head\":null,\"tail\":null},\"ghosts\":{\"head\":null,\"tail\":null},\"wall\":{\"head\":[8,8],\"tail\":{\"head\":[8,6],\"tail\":{\"head\":[8,4],\"tail\":{\"head\":[8,2],\"tail\":{\"head\":[8,0],\"tail\":{\"head\":[7,0],\"tail\":{\"head\":[6,8],\"tail\":{\"head\":[6,6],\"tail\":{\"head\":[6,4],\"tail\":{\"head\":[6,2],\"tail\":{\"head\":[6,0],\"tail\":{\"head\":[5,0],\"tail\":{\"head\":[4,8],\"tail\":{\"head\":[4,6],\"tail\":{\"head\":[4,4],\"tail\":{\"head\":[4,2],\"tail\":{\"head\":[4,0],\"tail\":{\"head\":[3,0],\"tail\":{\"head\":[2,8],\"tail\":{\"head\":[2,6],\"tail\":{\"head\":[2,4],\"tail\":{\"head\":[2,2],\"tail\":{\"head\":[2,0],\"tail\":{\"head\":[1,0],\"tail\":{\"head\":[0,8],\"tail\":{\"head\":[0,7],\"tail\":{\"head\":[0,6],\"tail\":{\"head\":[0,5],\"tail\":{\"head\":[0,4],\"tail\":{\"head\":[0,3],\"tail\":{\"head\":[0,2],\"tail\":{\"head\":[0,1],\"tail\":{\"head\":[0,0],\"tail\":{\"head\":null,\"tail\":null}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}")))
accept2  = TestCase (assertEqual "{\"bomb\":[1,1],\"surrounding\":{\"bombermans\":{\"head\":[1,1],\"tail\":{\"head\":null,\"tail\":null}},\"bricks\":{\"head\":[8,7],\"tail\":{\"head\":[8,3],\"tail\":{\"head\":[8,1],\"tail\":{\"head\":[6,7],\"tail\":{\"head\":[6,5],\"tail\":{\"head\":[5,8],\"tail\":{\"head\":[5,4],\"tail\":{\"head\":[3,6],\"tail\":{\"head\":[3,4],\"tail\":{\"head\":[2,3],\"tail\":{\"head\":[2,1],\"tail\":{\"head\":[1,8],\"tail\":{\"head\":[1,7],\"tail\":{\"head\":[1,6],\"tail\":{\"head\":null,\"tail\":null}}}}}}}}}}}}}}},\"gates\":{\"head\":null,\"tail\":null},\"ghosts\":{\"head\":null,\"tail\":null},\"wall\":{\"head\":[8,8],\"tail\":{\"head\":[8,6],\"tail\":{\"head\":[8,4],\"tail\":{\"head\":[8,2],\"tail\":{\"head\":[8,0],\"tail\":{\"head\":[7,0],\"tail\":{\"head\":[6,8],\"tail\":{\"head\":[6,6],\"tail\":{\"head\":[6,4],\"tail\":{\"head\":[6,2],\"tail\":{\"head\":[6,0],\"tail\":{\"head\":[5,0],\"tail\":{\"head\":[4,8],\"tail\":{\"head\":[4,6],\"tail\":{\"head\":[4,4],\"tail\":{\"head\":[4,2],\"tail\":{\"head\":[4,0],\"tail\":{\"head\":[3,0],\"tail\":{\"head\":[2,8],\"tail\":{\"head\":[2,6],\"tail\":{\"head\":[2,4],\"tail\":{\"head\":[2,2],\"tail\":{\"head\":[2,0],\"tail\":{\"head\":[1,0],\"tail\":{\"head\":[0,8],\"tail\":{\"head\":[0,7],\"tail\":{\"head\":[0,6],\"tail\":{\"head\":[0,5],\"tail\":{\"head\":[0,4],\"tail\":{\"head\":[0,3],\"tail\":{\"head\":[0,2],\"tail\":{\"head\":[0,1],\"tail\":{\"head\":[0,0],\"tail\":{\"head\":null,\"tail\":null}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}"
                     True (isRight (parseJson "{\"bomb\":[1,1],\"surrounding\":{\"bombermans\":{\"head\":[1,1],\"tail\":{\"head\":null,\"tail\":null}},\"bricks\":{\"head\":[8,7],\"tail\":{\"head\":[8,3],\"tail\":{\"head\":[8,1],\"tail\":{\"head\":[6,7],\"tail\":{\"head\":[6,5],\"tail\":{\"head\":[5,8],\"tail\":{\"head\":[5,4],\"tail\":{\"head\":[3,6],\"tail\":{\"head\":[3,4],\"tail\":{\"head\":[2,3],\"tail\":{\"head\":[2,1],\"tail\":{\"head\":[1,8],\"tail\":{\"head\":[1,7],\"tail\":{\"head\":[1,6],\"tail\":{\"head\":null,\"tail\":null}}}}}}}}}}}}}}},\"gates\":{\"head\":null,\"tail\":null},\"ghosts\":{\"head\":null,\"tail\":null},\"wall\":{\"head\":[8,8],\"tail\":{\"head\":[8,6],\"tail\":{\"head\":[8,4],\"tail\":{\"head\":[8,2],\"tail\":{\"head\":[8,0],\"tail\":{\"head\":[7,0],\"tail\":{\"head\":[6,8],\"tail\":{\"head\":[6,6],\"tail\":{\"head\":[6,4],\"tail\":{\"head\":[6,2],\"tail\":{\"head\":[6,0],\"tail\":{\"head\":[5,0],\"tail\":{\"head\":[4,8],\"tail\":{\"head\":[4,6],\"tail\":{\"head\":[4,4],\"tail\":{\"head\":[4,2],\"tail\":{\"head\":[4,0],\"tail\":{\"head\":[3,0],\"tail\":{\"head\":[2,8],\"tail\":{\"head\":[2,6],\"tail\":{\"head\":[2,4],\"tail\":{\"head\":[2,2],\"tail\":{\"head\":[2,0],\"tail\":{\"head\":[1,0],\"tail\":{\"head\":[0,8],\"tail\":{\"head\":[0,7],\"tail\":{\"head\":[0,6],\"tail\":{\"head\":[0,5],\"tail\":{\"head\":[0,4],\"tail\":{\"head\":[0,3],\"tail\":{\"head\":[0,2],\"tail\":{\"head\":[0,1],\"tail\":{\"head\":[0,0],\"tail\":{\"head\":null,\"tail\":null}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}")))
accept3  = TestCase (assertEqual "{}"
                     True (isRight (parseJson "{}")))
accept4  = TestCase (assertEqual "[string1, string2, string3]"
                     True (isRight (parseJsonList "[string1, string2, string3]")))
accept5  = TestCase (assertEqual "{}"  True (isRight (parseJson "{}")))
accept6  = TestCase (assertEqual "{\"\", 0}" True (isRight (parseJson "{\"\", 0}")))
accept7  = TestCase (assertEqual  "{\"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\":\"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\"}"
                     True (isRight (parseJson  "{\"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\":\"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\"}")))
accept8  = TestCase (assertEqual "{\"asd\":\"sdf\",\"dfg\":\"fgh\"}" 
                     True (isRight (parseJson "{\"asd\":\"sdf\",\"dfg\":\"fgh\"}")))
accept9  = TestCase (assertEqual "[1, 2, 3]" True (isRight (parseJsonList "[1, 2, 3]" )))
accept10 = TestCase (assertEqual  "[123]" True (isRight (parseJsonList "[123]" )))

parserAcceptTests = TestList [  TestLabel "accept1" accept1,
                                TestLabel "accept2" accept2,
                                TestLabel "accept3" accept3,
                                TestLabel "accept4" accept4,
                                TestLabel "accept5" accept5,
                                TestLabel "accept6" accept6,
                                TestLabel "accept7" accept7,
                                TestLabel "accept8" accept8,
                                TestLabel "accept9" accept9,
                                TestLabel "accept10" accept10
                              ]


reject1 = TestCase (assertEqual " :5" False (isRight (parseJson " :5")))
reject2 = TestCase (assertEqual "{\"a\3\":5,\"b\":[1,2,3],\"c\":{\"d\":5}}"  
                    False (isRight (parseJson "{\"a\3\":5,\"b\":[1,2,3],\"c\":{\"d\":5}}") ))
reject3  = TestCase (assertEqual "{[: \"x\"}"  False  (isRight (parseJson "{[: \"x\"}" )))
reject4  = TestCase (assertEqual "{\"x\"::\"b\"}"  False  (isRight (parseJson "{\"x\"::\"b\"}" )))
reject5  = TestCase (assertEqual "{\"a\":\"a\" 123}" False  (isRight (parseJson "{\"a\":\"a\" 123}" )))
reject6  = TestCase (assertEqual  "{'a':0}"  False (isRight (parseJson "{'a':0}" )))
reject7  = TestCase (assertEqual  "{\"a\":\"b\",,\"c\":\"d\"}" False (isRight (parseJson "{\"a\":\"b\",,\"c\":\"d\"}" )))
reject8  = TestCase (assertEqual  "{🇨🇭}" False (isRight (parseJson "{🇨🇭}" )))
reject9  = TestCase (assertEqual  "{#\"a\":\"b\"}" False (isRight (parseJson "{#\"a\":\"b\"}"  )))
reject10 = TestCase (assertEqual "{: \"x\"]}"  False  (isRight (parseJson "{: \"x\"]}" )))

parserRejectTests = TestList [  TestLabel "reject1" reject1,
                                TestLabel "reject2" reject2,
                                TestLabel "reject3" reject3,
                                TestLabel "reject4" reject4,
                                TestLabel "reject5" reject5,
                                TestLabel "reject6" reject6,
                                TestLabel "reject7" reject7,
                                TestLabel "reject8" reject8,
                                TestLabel "reject9" reject9,
                                TestLabel "reject10" reject10
                              ]

--________________________________________________________________________________
--                         HELPER FUNCTIONS' TESTS
--________________________________________________________________________________


acceptH1 = TestCase (assertEqual "for getHeight," 5 (getHeight' (JsonLikeObject [("height", JsonLikeInteger 5)])))
acceptH2 = TestCase (assertEqual "for getHeight," 5 (getWidth' (JsonLikeObject [("width", JsonLikeInteger 5)])))
acceptH3 = TestCase (assertEqual "for getUuid," "uuid" (getUuid (JsonLikeObject [("uuid", JsonLikeString "uuid")])))
acceptH4 = TestCase (assertEqual "for showJsonString, " "\"\\b\\n\\f\\r\\t'\\\"\\\\\\/\"" (showJsonString "\b\n\f\r\t\'\"\\/"))

helperTests = TestList [  TestLabel "acceptH1" acceptH1,
                          TestLabel "acceptH2" acceptH2,
                          TestLabel "acceptH3" acceptH3,
                          TestLabel "acceptH4" acceptH4
                        ]

main :: IO ()
main = do
  counts <- runTestTT parserAcceptTests
  counts <- runTestTT parserRejectTests
  counts <- runTestTT helperTests
  return ()
