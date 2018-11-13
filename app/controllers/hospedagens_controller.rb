class HospedagensController < ApplicationController

	# constantes
	URL_CONSULTAR = "http://localhost:8080/hospedagem/consultar"
	URL_COMPRAR = "http://localhost:8080/hospedagem/comprar"
	HEADERS = {'Content-type': 'application/json'}
	MSG_ERRO_COMUNICACAO = "Erro ao acessar o serviço. Tente novamente mais tarde"

	# variáveis de instância
	@funcao

	# variáveis da classe
	@@logger = Logger.new File.new('hospedagem.log', 'w')

	# ação que renderiza o formulário de consulta/compra de hospedagem
	def index
		# recupera parâmetro da url, salva em uma variável de instância e salva na sessão
		@funcao = params['funcao']
		@@logger.info('HospedagensController index funcao = ') { @funcao }
		session['funcao'] = @funcao
	end

	# ação que recupera os dados do formulário para fazer a requisição ao web service
	def create
		# recuperando paramêtros do formulário
		hospedagem = params.require(:hospedagem).permit(:dataEntrada, :dataSaida, :origem, :destino, :numeroPessoas, :numeroQuartos)
		# recupera funcao da sessão
		@funcao = session['funcao']
		
		# loggando as informações relevantes
		@@logger.info('HospedagensController recuperando objeto') { hospedagem.to_s }
		@@logger.info('HospedagensController funcao = ') { @funcao }
		
		# converte o hash do formulário em um JSON
		hospedagem_json = { 
			'dataEntrada': hospedagem['dataEntrada'],
			'dataSaida': hospedagem['dataSaida'],
			'origem': hospedagem['origem'],
			'destino': hospedagem['destino'],
			'numeroPessoas': hospedagem['numeroPessoas'],
			'numeroQuartos': hospedagem['numeroQuartos']
		}.to_json

		@@logger.info('HospedagensController JSON = ') { hospedagem_json }

		# define a url a ser chamada
		url = defineUrl(@funcao)

		# chama a API
		begin
			resposta = self.acessarWebService(url, HEADERS).post hospedagem_json
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
