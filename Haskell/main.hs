esDivisor :: Int -> Int -> Bool
esDivisor n d = mod n d == 0

divisoresPropios :: Int -> [Int]
divisoresPropios n = filter (esDivisor n) [1 .. n - 1]

sumaAlicuota :: Int -> Int
sumaAlicuota n = sum (divisoresPropios n)

clasificarCategoria :: Int -> String
clasificarCategoria n =
    if sumaAlicuota n > n then
        "Administrative"
    else if sumaAlicuota n == n then
        "Engineering"
    else
        "Humanities"

periodoTexto :: Int -> String
periodoTexto p = "20" ++ show (div p 10) ++ "-" ++ show (mod p 10)

paridad :: Int -> String
paridad n =
    if mod n 2 == 0 then
        "even"
    else
        "odd"

periodoValido :: Int -> Bool
periodoValido p = p == 262 || p == 271 || p == 272 || p == 281 ||p == 282 || p ==291 || p == 292

codigoValido :: Int -> Bool
codigoValido codigo =
    if codigo < 10000000 then
        False
    else if codigo > 99999999 then
        False
    else if mod (div codigo 1000) 100 == 0 then
        False
    else if mod codigo 1000 == 0 then
        False
    else
        periodoValido (div codigo 100000)

analizarCodigo :: Int -> String
analizarCodigo codigo =
    periodoTexto (div codigo 100000) ++ " " ++
    clasificarCategoria (mod (div codigo 1000) 100) ++ " " ++
    "num" ++ show (mod codigo 1000) ++ " " ++
    paridad codigo

procesarLinea :: String -> String
procesarLinea linea =
    let intentos = (reads linea) :: [(Int, String)] in
    if null intentos then
        "Invalid code: " ++ linea
    else if snd (head intentos) /= "" then
        "Invalid code: " ++ linea
    else
        let codigo = fst (head intentos) in
        if codigoValido codigo then
            analizarCodigo codigo
        else
            "Invalid code: " ++ show codigo

mostrarTodos :: [String] -> IO ()
mostrarTodos [] = return ()
mostrarTodos (linea : resto) = do
    putStrLn (procesarLinea linea)
    mostrarTodos resto
    
main :: IO ()
main = do
    entrada <- getContents
    let lineasCodigos = takeWhile (/= "") (lines entrada)
    mostrarTodos lineasCodigos
