class RespostasController < ApplicationController

	@resposta

	def index
		@resposta = session['resposta']
	end

end
