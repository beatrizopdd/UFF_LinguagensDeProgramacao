import Text.Printf

-- Abre o arquivo e divide o conteúdo por linha
abreArquivo :: String -> IO [String]
abreArquivo caminho = do
  conteudo <- readFile caminho
  return (lines conteudo)

-- Conta caracteres diferentes
cont_dif :: String -> String -> Double
cont_dif [] [] = 0
cont_dif [] m = fromIntegral (length m)
cont_dif o [] = fromIntegral (length o)
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
  if distLinha > 0.25 then 
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
  return (dividendo/divisor)

-- Calcula o diff-HA
diffHA :: (Float, Float) -> [String] -> [String] -> IO ()
diffHA (diffHaTotal, tamArq) [] [] = return ()
-- Se um arquivo acabou, mas ainda há linhas no outro, imprime como novas linhas adicionadas
diffHA (diffHaTotal, tamArq) [] (hm:tm) = do
  dis_ha <- hammingLinha [] hm
  let diffchar = length hm
  let mediaDoArquivo = diffHaTotal / tamArq

  print "-------------------------------------------"
  printf "Média até aqui: %.2f \n" mediaDoArquivo
  printf "( ) | (+) %s \n" hm
  printf "Caracteres diferentes na linha: %d \n" diffchar
  printf "Distância Hamming da linha: %.2f \n" dis_ha
  diffHA (diffHaTotal, tamArq) [] tm

-- Se um arquivo acabou, mas ainda há linhas no outro, imprime como linhas removidas
diffHA (diffHaTotal, tamArq) (ho:to) [] = do
  dis_ha <- hammingLinha ho []
  let diffchar = length ho
  let mediaDoArquivo = diffHaTotal / tamArq

  print "-------------------------------------------"
  printf "Média até aqui: %.2f \n" mediaDoArquivo
  printf "(-) %s | ( ) \n" ho
  printf "Caracteres diferentes na linha: %d \n" diffchar
  printf "Distância Hamming da linha: %.2f \n" dis_ha
  diffHA (diffHaTotal, tamArq) to []

diffHA (diffHaTotal, tamArq) (ho:to) (hm:tm) = do
  dis_ha <- hammingLinha ho hm
  let diffchar = cont_dif ho hm
  let mediaDoArquivo = diffHaTotal / tamArq

  print "-------------------------------------------"
  printf "Média até aqui: %.2f \n" mediaDoArquivo
  -- Se for igual a 100%, considera uma linha mantida
  if dis_ha == 1 then do
      printf "(=) %s | (=) %s \n" ho hm
      printf "Caracteres diferentes na linha: %.2f \n" diffchar
      printf "Distância Hamming da linha: %.2f \n" dis_ha
      diffHA (diffHaTotal, tamArq) to tm

  -- Se for maior que 25%, considera uma linha alterada, que vai entrar no cálculo da média
  else if dis_ha > 0.25 then do
      printf "(-) %s | (+) %s \n" ho hm
      printf "Caracteres diferentes na linha: %.2f \n" diffchar
      printf "Distância Hamming da linha: %.2f \n" dis_ha
      diffHA (diffHaTotal+dis_ha, tamArq+1) to tm

  else do
    -- Se não acha uma linha compatível, considera uma linha adicionada
    eh_adc <- verificaExistencia to hm
    if (eh_adc == 0) then do
      printf "( ) | (+) %s \n" hm
      printf "Caracteres diferentes na linha: %.2f \n" diffchar
      printf "Distância Hamming da linha: %.2f \n" dis_ha
      diffHA (diffHaTotal, tamArq) (ho:to) tm

    -- Se a distância Hamming for igual a 0%, considera uma linha adicionada
    else do
        printf "(-) %s | ( )  \n" ho
        printf "Caracteres diferentes na linha: %.2f \n" diffchar
        printf "Distância Hamming da linha: %.2f \n" dis_ha
        diffHA (diffHaTotal, tamArq) to (hm:tm)

-- B: Onde ocorre a execução principal
main :: IO ()
main = do
    -- B: abre os arquivos e transforma em lista com as linhas
    conteudoOriginal <- abreArquivo "arquivos/original.txt"
    conteudoModificado <- abreArquivo "arquivos/modificado.txt"

    -- Comparação linha a linha
    diffHA (0.0, 0.0) conteudoOriginal conteudoModificado
    
-- Abre o arquivo e adiciona uma linha
escreveArquivo :: String -> [String] -> IO ()
escreveArquivo caminho [] = return ()
escreveArquivo caminho (linha:resto) = do
  appendFile caminho (linha ++ "\n")
  escreveArquivo caminho resto

