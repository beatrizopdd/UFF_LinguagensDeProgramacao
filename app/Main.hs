abreArquivo :: String -> IO [String]
abreArquivo caminho = do
  conteudo <- readFile caminho
  return (lines conteudo)

-- Conta caracteres diferentes
cont_dif :: String -> String -> Int
cont_dif [] [] = 0
cont_dif [] m = length m
cont_dif o [] = length o
cont_dif (ho:to) (hm:tm) | ho /= hm  = 1 + cont_dif to tm | otherwise = cont_dif to tm


-- Conta caracteres iguais
cont_igual :: String -> String -> Int
cont_igual [] [] = 0
cont_igual [] m = 0
cont_igual o [] = 0
cont_igual (ho:to) (hm:tm) | ho == hm  = 1 + cont_igual to tm | otherwise = cont_igual to tm

-- B: Onde ocorre a execução principal
main :: IO ()
main = do
    -- B: abre os arquivos e tranforma em lista com as linhas
    conteudoOriginal <- abreArquivo "arquivos/original.txt"
    conteudoModificado <- abreArquivo "arquivos/modificado.txt"

    let result_dif = cont_dif "abobrinha" "abobora" --resultado do contador de caracteres diferentes ok
    print result_dif

    let result_igual = cont_igual "abobrinha" "abobora" --resultado do contador de caracteres iguais ok
    print result_igual 



