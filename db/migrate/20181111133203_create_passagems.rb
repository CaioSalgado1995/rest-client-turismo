class CreatePassagems < ActiveRecord::Migration[5.0]
  def change
    create_table :passagems do |t|
      t.string :dataIda
      t.string :dataVolta
      t.string :origem
      t.string :destino
      t.string :numeroPessoas
      t.string :tipo

      t.timestamps
    end
  end
end
