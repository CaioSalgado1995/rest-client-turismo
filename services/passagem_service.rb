class PassagemService
	attr_reader :base_url

	def initialize
		@base_url = "https://localhost:8080/passagem"
	end

	def headers
		{
			'Accept': 'application/json',
			'Content-type': 'application/json'
		}
	end

	def consultar
		url = @base_url + "/consultar"
		RestClient::Resource.new(url, { headers: headers })
	end

	def parse(request)
		JSON.parse(request.body)
	end
end