import Text.Printf

-- Abre o arquivo e divide o conteúdo por linha
abreArquivo :: String -> IO [String]
abreArquivo caminho = do
  conteudo <- readFile caminho
  return (lines conteudo)

-- Abre o arquivo e adiciona uma linha
escreveArquivo :: String -> [String] -> IO ()
escreveArquivo caminho [] = return ()
escreveArquivo caminho (linha:resto) = do
  appendFile caminho (linha ++ "\n")
  escreveArquivo caminho resto

-- Conta caracteres diferentes
cont_dif :: String -> String -> Int
cont_dif [] [] = 0
cont_dif [] m = length m
cont_dif o [] = length o
cont_dif (ho:to) (hm:tm)
  | ho /= hm  = 1 + cont_dif to tm
  | otherwise = cont_dif to tm

-- Conta caracteres iguais
cont_igual :: String -> String -> Int
cont_igual [] [] = 0
cont_igual [] _ = 0
cont_igual _ [] = 0
cont_igual (ho:to) (hm:tm)
  | ho == hm  = 1 + cont_igual to tm
  | otherwise = cont_igual to tm

-- B: Descobre a maior string
comparaTamanho :: String -> String -> Int
comparaTamanho o m = max (length o) (length m)

-- Verifica se é uma linha adicionada
verificaExistencia :: [String] -> String -> IO Int
verificaExistencia [] linha = return 0
verificaExistencia (ho:to) linha = do
  distLinha <- hammingLinha ho linha
  if distLinha > 25 then 
    return 1
  else
    verificaExistencia to linha

-- Calcula a distância hamming
hammingLinha :: String -> String -> IO Float
-- Ele calcula o número de caracteres iguais das duas linhas e depois divide esse número pelo tamanho da maior linha
hammingLinha original modificado = do
  let iguais = cont_igual original modificado
  let dividendo = fromIntegral iguais
  let divisor = fromIntegral (comparaTamanho original modificado)
  let porcentagem = dividendo * 100 / divisor
  return porcentagem

-- Calcula o diff-HA
diffHA :: [String] -> [String] -> IO ()
diffHA [] [] = return ()
-- Se um arquivo acabou, mas ainda há linhas no outro, imprime como novas linhas adicionadas
diffHA [] (hm:tm) = do
  printf "( ) | (+) %s \n" hm
  diffHA [] tm
-- Se um arquivo acabou, mas ainda há linhas no outro, imprime como linhas removidas
diffHA (ho:to) [] = do
  printf "(-) %s | ( ) \n" ho
  diffHA to []
diffHA (ho:to) (hm:tm) = do
  distLinha <- hammingLinha ho hm
  -- Se for igual a 100%, considera uma linha mantida
  if distLinha == 100 then do
      printf "(=) %s | (=) %s \n" ho hm
      printf "Distância Hamming: %.2f%%\n" distLinha
      diffHA to tm

  -- Se for maior que 25%, considera uma linha alterada, que vai entrar no cálculo da média
  else if distLinha > 25 then do
      printf "(-) %s | (+) %s \n" ho hm
      printf "Distância Hamming: %.2f%%\n" distLinha
      diffHA to tm

  else do
    -- Se não acha uma linha compatível, considera uma linha adicionada
    eh_adc <- verificaExistencia to hm
    print eh_adc
    if (eh_adc == 0) then do
      printf "( ) | (+) %s \n" hm
      printf "Distância Hamming: %.2f%%\n" distLinha
      diffHA (ho:to) tm

    -- Se a distância Hamming for igual a 0%, considera uma linha adicionada
    else do
        printf "(-) %s | ( )  \n" ho
        printf "Distância Hamming: %.2f%%\n" distLinha
        diffHA to (hm:tm)

-- B: Onde ocorre a execução principal
main :: IO ()
main = do
    -- B: abre os arquivos e transforma em lista com as linhas
    conteudoOriginal <- abreArquivo "arquivos/original.txt"
    conteudoModificado <- abreArquivo "arquivos/modificado.txt"

    -- Tamanho do arquivo original
    printf "Tamanho original: %d\n" (length conteudoOriginal)

    -- Comparação linha a linha
    diffHA conteudoOriginal conteudoModificado

    -- B: abre o novo arquivo e adiciona uma linha
    --escreveArquivo "arquivos/novo.txt" ["um", "dois", "tres", "quatro"]
