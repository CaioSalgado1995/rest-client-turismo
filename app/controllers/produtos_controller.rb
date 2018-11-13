class ProdutosController < ApplicationController

	def index
	end

	def create
		produto = params.require(:produto).permit(:nome, :descricao, :preco, :quantidade)
		Produto.create produto
		redirect_to "/produtos"
	end
end
