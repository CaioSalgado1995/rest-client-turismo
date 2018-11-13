Rails.application.routes.draw do

	root "produtos#index"

	# rotas de produtos - exemplos
	post "produtos", to: "produtos#create"
	get "produtos", to: "produtos#index"
	get "produtos/formulario", to: "produtos#formulario"
	
	# rotas de passagens
	post "passagens", to: "passagens#create"
	get "passagens", to: "passagens#index"
	
	# rotas de hospedagens
	post "hospedagens", to: "hospedagens#create"
	get "hospedagens", to: "hospedagens#index"

	# rotas de pacote
	post "pacotes", to: "pacotes#create"
	get "pacotes", to: "pacotes#index"

	get "respostas", to: "respostas#index"

end
