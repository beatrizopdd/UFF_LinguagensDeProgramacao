abreArquivo :: String -> IO [String]
abreArquivo caminho = do
  conteudo <- readFile caminho
  return (lines conteudo)

-- B: Onde ocorre a execução principal
main :: IO ()
main = do
    -- B: abre os arquivos e tranforma em lista com as linhas
    conteudoOriginal <- abreArquivo "arquivos/original.txt"
    conteudoModificado <- abreArquivo "arquivos/modificado.txt"

    print conteudoOriginal
    print "\n"
    print conteudoModificado