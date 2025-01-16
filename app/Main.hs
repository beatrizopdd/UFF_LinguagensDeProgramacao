abreArquivo :: String -> IO [String]
abreArquivo caminho = do
  conteudo <- readFile caminho
  return (lines conteudo)

escreveArquivo :: String -> [String] -> IO ()
escreveArquivo caminho [] = appendFile caminho ""
escreveArquivo caminho (linha:resto) = do
  appendFile caminho (linha ++ "\n")
  escreveArquivo caminho resto

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

-- Calcula a distância hamming
hammingLinha :: String -> String -> IO Int
--hammingLinha original modificado = do 
--ele calcula o numero de caracteres iguais das duas linhas e depois divide esse numero pelo tamanho da maior linha 

-- Calcula o diff-HA
diffHA :: [String] -> [String] -> (Int, [String])
--se o hammingLinha for menor que 25%, então ele considera uma nova linha
--se for maior que 25% então considera uma linha alterada, que vai entrar no calculo da media
diffHA (ho:to) (hm:tm) = do 
let dist_linha = hammingLinha ho hm
let media = 0
if dist_linha < 25 then diffHA to (hm:tm) else diffHA to tm
--se a linha for < 25: salva como (-) ho; se a linha for > 25: salva como (+) hm
return 





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

    -- B: abre o novo arquivo e adiciona uma linha
    escreveArquivo "arquivos/novo.txt" ["um", "dois", "tres", "quatro"]