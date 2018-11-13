class CreatePacotes < ActiveRecord::Migration[5.0]
  def change
    create_table :pacotes do |t|
      t.string :dataIda
      t.string :dataVolta
      t.string :origem
      t.string :destino
      t.string :numeroPessoas
      t.string :tipoPassagem
      t.string :numeroQuartos

      t.timestamps
    end
  end
end
