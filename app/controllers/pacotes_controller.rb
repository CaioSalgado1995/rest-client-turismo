class PacotesController < ApplicationController
	# constantes
	URL_CONSULTAR = "http://localhost:8080/pacote/consultar"
	URL_COMPRAR = "http://localhost:8080/pacote/comprar"
	HEADERS = {'Content-type': 'application/json'}
	MSG_ERRO_COMUNICACAO = "Erro ao acessar o serviço. Tente novamente mais tarde"

	# variáveis de instância
	@funcao

	# variáveis da classe
	@@logger = Logger.new File.new('pacote.log', 'w')

	# ação que renderiza o formulário de consulta/compra de hospedagem
	def index
		# recupera parâmetro da url, salva em uma variável de instância e salva na sessão
		@funcao = params['funcao']
		@@logger.info('PacotesController index funcao = ') { @funcao }
		session['funcao'] = @funcao
	end

	# ação que recupera os dados do formulário para fazer a requisição ao web service
	def create
		# recuperando paramêtros do formulário
		pacote = params.require(:pacote).permit(:dataIda, :dataVolta, :origem, :destino, :numeroPessoas, :tipoPassagem, :numeroQuartos)
		# recupera funcao da sessão
		@funcao = session['funcao']
		
		# loggando as informações relevantes
		@@logger.info('PacotesController recuperando objeto') { pacote.to_s }
		@@logger.info('PacotesController funcao = ') { @funcao }
		
		# converte o hash do formulário em um JSON
		passagem_json =  {
			'dataIda': pacote['dataIda'],
			'dataVolta': pacote['dataVolta'],
			'origem': pacote['origem'],
			'destino': pacote['destino'],
			'numeroPessoas': pacote['numeroPessoas'],
			'tipo': pacote['tipoPassagem']
		}

		hospedagem_json = {
			'dataEntrada': pacote['dataIda'],
			'dataSaida': pacote['dataVolta'],
			'origem': pacote['origem'],
			'destino': pacote['destino'],
			'numeroPessoas': pacote['numeroPessoas'],
			'numeroQuartos': pacote['numeroQuartos']
		}

		pacote_json = {
			'passagem': passagem_json,
			'hospedagem': hospedagem_json
		}.to_json

		@@logger.info('PacotesController JSON = ') { pacote_json }

		# define a url a ser chamada
		url = defineUrl(@funcao)

		# chama a API
		begin
			resposta = self.acessarWebService(url, HEADERS).post pacote_json
		rescue Exception => e
			resposta = MSG_ERRO_COMUNICACAO
			@@logger.info("HospedagensController erro => ") { e.message }
		end

		@@logger.info('Resposta a chamada a API') {resposta.to_s}

		# salva a resposta na sessão
		session['resposta'] = resposta

		# fecha o log
		@@logger.close

		# redireciona para a página que exibe a resposta do Web Service
		redirect_to "/respostas"
	end

	# método que abre a conexão com o Web Service
	# url     => url a ser chamada
	# headers => headers necessários para comunicação, nesse caso somente especifica comunicação
	#            via JSON 
	def acessarWebService(url, headers)
		begin
			RestClient::Resource.new(url, { headers: headers })
		rescue Exception
			raise Exception.new(MSG_ERRO_COMUNICACAO)
		end
	end

	# método que define qual url deverá ser utilizada dependendo da função contida no parâmetro da url
	# funcao => funcao 
	def defineUrl(funcao)
		funcao == "consultar" ? URL_CONSULTAR : URL_COMPRAR
	end
end
