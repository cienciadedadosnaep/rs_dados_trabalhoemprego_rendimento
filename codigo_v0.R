######################################################
# 1) Carregar bibliotecas

library(tidyverse)
library(magrittr)
#library(dplyr)
library(readr)
library(rjson)
library(RJSONIO)

# # Library para importar dados SQL
# library(DBI)
# library(RMySQL)
# library(pool)
# library(sqldf)
# library(RMariaDB)
# 
# # Carragamento de banco de dados
# 
# # Settings
# db_user <-'admin'
# db_password <-'password'
# db_name <-'cdnaep'
# #db_table <- 'your_data_table'
# db_host <-'127.0.0.1' # for local access
# db_port <-3306
# 
# # 3. Read data from db
# # drv=RMariaDB::MariaDB(),
# mydb <-  dbConnect(drv =RMariaDB::MariaDB(),user =db_user, 
#                    password = db_password ,
#                    dbname = 'cdnaep', host = db_host, port = db_port)
# 
# dbListTables(mydb)
# 
# s <- paste0("SELECT * from", " consumo_agua")
# rs<-NULL
# rs <- dbSendQuery(mydb, s)
# 
# dados<- NULL
# dados <-  dbFetch(rs, n = -1)
# dados
# #dbHasCompleted(rs)
# #dbClearResult(rs)

library(readr)
dados <- read_csv("data/recossa_rendimento.csv")
names(dados)

##  Perguntas e titulos 
T_ST_P_No_TRABALHOEMPREGO <- read_csv("data/TEMA_SUBTEMA_P_No - TRABALHOEMPREGO.csv")

dados %<>% gather(key = classe,
                  value = valor,-trimestre) 
#dados %<>% select(-id)
# Temas Subtemas Perguntas



## Arquivo de saida 

SAIDA_POVOAMENTO <- T_ST_P_No_TRABALHOEMPREGO %>% 
  select(TEMA,SUBTEMA,PERGUNTA,NOME_ARQUIVO_JS)
SAIDA_POVOAMENTO <- as.data.frame(SAIDA_POVOAMENTO)

classes <- NULL
classes <- levels(as.factor(dados$classe))

# Cores secundarias paleta pantone -
corsec_recossa_azul <- c('#a094e1','#dc6f6c','#62acd1','#8bc6d2',
                         '#d62839','#20cfef','#fe4641','#175676')
# Cor 1 - Roxo; Cor 2, 5, 7 - Vermelho; Cor 3, 4, 6, 8 - Azul

#for ( i in 1:length(classes)) {
  
  objeto_0 <- dados %>%
    filter(classe %in% c(classes[1])) %>%
    select(trimestre,valor) %>% #filter(ano<2019) %>%
    #arrange(trimestre) %>%
    mutate(trimestre = as.character(trimestre)) %>% list()               
  
  exportJson0 <- toJSON(objeto_0)
  
  
  titulo<-T_ST_P_No_TRABALHOEMPREGO$TITULO[1]
  subtexto<-"Fonte: SIDRA IBGE"
  link <- T_ST_P_No_TRABALHOEMPREGO$LINK[1]
  
  data_axis <- paste('["',gsub(' ','","',
                              paste(paste(as.vector(objeto_0[[1]]$trimestre)),
                                   collapse = ' ')),'"]',sep = '')
  
  
  data_serie <- paste('[',gsub(' ',',',
                               paste(paste(as.vector(objeto_0[[1]]$valor)),
                                     collapse = ' ')),']',sep = '')
  
  texto<-paste('{"title":{"text":"',titulo,
               '","subtext":"',subtexto,
               '","sublink":"',link,'"},',
               '"tooltip":{"trigger":"axis"},',
               '"toolbox":{"left":"center","orient":"horizontal","itemSize":20,"top":45,"show":true,',
               '"feature":{"dataZoom":{"yAxisIndex":"none"},',
               '"dataView":{"readOnly":false},',
               '"restore":{},"saveAsImage":{}}},"xAxis":{"type":"category",',
               '"data":',data_axis,'},',
               '"yAxis":{"type":"value","axisLabel":{"formatter":"R$ {value}"}},',
               '"series":[{"data":',data_serie,',',
               '"type":"line","color":"',corsec_recossa_azul[1],'","showBackground":true,',
               '"backgroundStyle":{"color":"rgba(180, 180, 180, 0.2)"},',
               '"itemStyle":{"borderRadius":10,"borderColor":"',corsec_recossa_azul[1],'","borderWidth":2}}]}',sep='')
  
  #SAIDA_POVOAMENTO$CODIGO[i] <- texto   
  texto<-noquote(texto)
  
  
  write(exportJson0,file = paste('data/',gsub('.csv','',T_ST_P_No_TRABALHOEMPREGO$NOME_ARQUIVO_JS[1]),
                                 '.json',sep =''))
  write(texto,file = paste('data/',T_ST_P_No_TRABALHOEMPREGO$NOME_ARQUIVO_JS[1],
                           sep =''))
  
#}

# Arquivo dedicado a rotina de atualizacao global. 

write_csv2(SAIDA_POVOAMENTO,file ='data/POVOAMENTO.csv',quote='all',escape='none')
#quote="needed")#,escape='none')


objeto_autm <- SAIDA_POVOAMENTO %>% list()
exportJson_aut <- toJSON(objeto_autm)

#write(exportJson_aut,file = paste('data/povoamento.json'))