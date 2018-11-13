require 'logger'
require 'json'

class PassagensController < ApplicationController

	@funcao

	def index
		logger = Logger.new File.new('passagem.log', 'w')
		# recupera parâmetro da url para verificar se é compra ou consulta
		@funcao = params['funcao']
		logger.info('PassagensController index funcao = ') { @funcao }

		session['funcao'] = @funcao
	end

	def create
		# recuperando paramêtros do formulário
		passagem = params.require(:passagem).permit(:dataIda, :dataVolta, :origem, :destino, :numeroPessoas, :tipo)

		# recupera cada propriedade individualmente
		dataIda = passagem['dataIda']
		dataVolta = passagem['dataVolta']
		origem = passagem['origem']
		destino = passagem['destino']
		numeroPessoas = passagem['numeroPessoas']
		tipo = passagem['tipo']

		@funcao = session['funcao']
		
		# loggando as informações
		logger = Logger.new File.new('passagem.log', 'w')
		logger.info('PassagensController recuperando objeto') { passagem.to_s }
		logger.info('PassagensController dataIda = ') { dataIda }
		logger.info('PassagensController dataVolta = ') { dataVolta }
		logger.info('PassagensController origem = ') { origem }
		logger.info('PassagensController destino = ') { destino }
		logger.info('PassagensController numeroPessoas = ') { numeroPessoas }
		logger.info('PassagensController tipo = ') { tipo }
		logger.info('PassagensController funcao = ') { @funcao }
		
		# converte o hash do formulário em um JSON
		passagem_json = { 
			'dataIda': dataIda,
			'dataVolta': dataVolta,
			'origem': origem,
			'destino': destino,
			'numeroPessoas': numeroPessoas,
			'tipo': tipo
		}.to_json

		logger.info('PassagensController JSON = ') { passagem_json }

		# chama a API e obtem a resposta
		if @funcao == "consultar"
			resposta = self.consultar.post passagem_json
		elsif @funcao == "comprar"
			resposta = self.comprar.post passagem_json
		end

		# converte a resposta para um hash
		resposta_hash = {
			'retorno' => resposta
		}

		logger.info('Resposta a chamada a API') {resposta.to_s}

		# Grava no banco a resposta
		#Resposta.create resposta_hash.symbolize_keys

		# fecha o log
		logger.close

		session['resposta'] = resposta

		# Redireciona para a página de retornos
		redirect_to "/respostas"
	end


	def consultar
		url = "http://localhost:8080/passagem/consultar"
		headers = {
			'Content-type': 'application/json'
		}
		RestClient::Resource.new(url, { headers: headers })
	end

	def comprar
		url = "http://localhost:8080/passagem/comprar"
		headers = {
			'Content-type': 'application/json'
		}
		RestClient::Resource.new(url, { headers: headers })
	end

end
