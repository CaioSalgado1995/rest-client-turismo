class CreateHospedagems < ActiveRecord::Migration[5.0]
  def change
    create_table :hospedagems do |t|
      t.string :origem
      t.string :destino
      t.string :dataEntrada
      t.string :dataSaida
      t.integer :numeroQuartos
      t.integer :numeroPessoas
      t.integer :preco

      t.timestamps
    end
  end
end
