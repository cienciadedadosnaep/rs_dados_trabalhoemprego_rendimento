import pandas as pd

df = pd.read_json('https://apisidra.ibge.gov.br/values/t/6472/n6/2927408/v/5929,5933,9132,9133,9136,9137,9138,9141,9142,9143,9146,9147,9148,9151/p/all?formato=json')
#df.info()
selecao = 'Rendimento médio nominal de todos os trabalhos, habitualmente recebido por mês, pelas pessoas de 14 anos ou mais de idade, ocupadas na semana de referência, com rendimento de trabalho'
grafico = df[["D3N","V","D2N"]]
grafico = grafico[grafico['D2N']==selecao]
graf2 = grafico[['D3N','V']]
#graf2.info()
#print(graf2.tail(10))
graf2 = graf2.drop([34,35,36,37,38])
#print(graf2.tail(10))
graf2.rename(columns={'D3N': 'trimestre', 'V': 'valor'}, inplace=True)
#print(graf2.head(5))
graf2['trimestre'] = graf2['trimestre'].replace(['1º trimestre 2012','2º trimestre 2012','3º trimestre 2012','4º trimestre 2012','1º trimestre 2013','2º trimestre 2013','3º trimestre 2013',\
    '4º trimestre 2013','1º trimestre 2014','2º trimestre 2014','3º trimestre 2014','4º trimestre 2014','1º trimestre 2015','2º trimestre 2015','3º trimestre 2015','4º trimestre 2015',\
        '1º trimestre 2016','2º trimestre 2016','3º trimestre 2016','4º trimestre 2016','1º trimestre 2017','2º trimestre 2017','3º trimestre 2017','4º trimestre 2017','1º trimestre 2018',\
            '2º trimestre 2018','3º trimestre 2018','4º trimestre 2018','1º trimestre 2019','2º trimestre 2019','3º trimestre 2019','4º trimestre 2019','1º trimestre 2020'], ['1ºtri2012','2ºtri2012','3ºtri2012','4ºtri2012','1ºtri2013','2ºtri2013','3ºtri2013',\
    '4ºtri2013','1ºtri2014','2ºtri2014','3ºtri2014','4ºtri2014','1ºtri2015','2ºtri2015','3ºtri2015','4ºtri2015',\
        '1ºtri2016','2ºtri2016','3ºtri2016','4ºtri2016','1ºtri2017','2ºtri2017','3ºtri2017','4ºtri2017','1ºtri2018',\
            '2ºtri2018','3ºtri2018','4ºtri2018','1ºtri2019','2ºtri2019','3ºtri2019','4ºtri2019','1ºtri2020'])
print(graf2)
graf2.to_csv('E:/Área de trabalho/Códigos/R/rs_dados_trabalhoemprego_rendimento/recossa_rendimento.csv', index=False)
