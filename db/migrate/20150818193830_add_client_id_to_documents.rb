class AddClientIdToDocuments < ActiveRecord::Migration
  def change
  	add_column :documents, :client_id, :integer
  end
end
