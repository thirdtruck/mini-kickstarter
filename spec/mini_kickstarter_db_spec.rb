require './lib/mini_kickstarter_db'

describe MiniKickstarterDB do
  describe '#list_backings' do
    let(:db) { MiniKickstarterDB.new(':memory:') }
    let(:project_name) { 'Example Project' }

    before do
      db.create_project(project_name, 50000)
      project_id = db.find_project_id_by_project_name(project_name)
      db.back_project('John', project_id, '5474942730093167', 5000)
    end

    it 'lists the backings for a project' do
      project = db.find_project_by_project_name(project_name)
      project_id = project[0]
      backings = db.find_backings_for_project_by_project_id(project_id)
      binding.pry
      pending 'WIP'
    end
  end
end
