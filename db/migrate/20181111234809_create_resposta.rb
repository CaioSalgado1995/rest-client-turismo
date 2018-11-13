class CreateResposta < ActiveRecord::Migration[5.0]
  def change
    create_table :resposta do |t|
      t.string :retorno

      t.timestamps
    end
  end
end
