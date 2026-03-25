require 'rake'

RSpec.describe 'bootstrap rake tasks' do # rubocop:disable RSpec/DescribeClass
  before(:all) do # rubocop:disable RSpec/BeforeAfterAll
    Rake.application = Rake::Application.new
    Rake.application.rake_require('tasks/bootstrap', [File.expand_path('../../lib', __dir__)])
  end

  let(:tmp_dir) { Dir.mktmpdir }

  after { FileUtils.remove_entry(tmp_dir) }

  def run_task(name, *)
    task = Rake::Task[name]
    task.reenable
    capture_stdout { task.invoke(*) }
  end

  def capture_stdout
    output = StringIO.new
    $stdout = output
    yield
    output.string
  ensure
    $stdout = STDOUT
  end

  describe 'bootstrap:version' do
    it 'prints version when .bootstrap-version exists' do
      File.write(File.join(tmp_dir, '.bootstrap-version'), "5.3.8\n")

      output = run_task('bootstrap:version', tmp_dir)

      expect(output.strip).to eq('5.3.8')
    end

    it 'prints help message when no .bootstrap-version exists' do
      output = run_task('bootstrap:version', tmp_dir)

      expect(output).to include('No .bootstrap-version file found')
      expect(output).to include('rake bootstrap:init')
    end
  end

  describe 'bootstrap:latest' do
    it 'prints the latest version' do
      output = run_task('bootstrap:latest')

      expect(output.strip).to eq('5.3.8')
    end

    it 'prints the latest version for a constraint' do
      output = run_task('bootstrap:latest', '4')

      expect(output.strip).to eq('4.6.2')
    end
  end

  describe 'bootstrap:status' do
    it 'reports up to date when current matches latest' do
      File.write(File.join(tmp_dir, '.bootstrap-version'), "5.3.8\n")

      output = run_task('bootstrap:status', nil, tmp_dir)

      expect(output).to include('up to date')
    end

    it 'reports behind when current is older' do
      File.write(File.join(tmp_dir, '.bootstrap-version'), "5.2.3\n")

      output = run_task('bootstrap:status', nil, tmp_dir)

      expect(output).to include('behind')
      expect(output).to include('5.3.8')
    end

    it 'prints help when no version file exists' do
      output = run_task('bootstrap:status', nil, tmp_dir)

      expect(output).to include('No .bootstrap-version file found')
    end
  end

  describe 'bootstrap:init' do
    it 'creates .bootstrap-version with latest version' do
      output = run_task('bootstrap:init', nil, tmp_dir)

      expect(output).to include('created')
      expect(output).to include('5.3.8')
      expect(File.read(File.join(tmp_dir, '.bootstrap-version')).strip).to eq('5.3.8')
    end

    it 'warns when file already exists' do
      File.write(File.join(tmp_dir, '.bootstrap-version'), "5.2.3\n")

      output = run_task('bootstrap:init', nil, tmp_dir)

      expect(output).to include('already exists')
      expect(File.read(File.join(tmp_dir, '.bootstrap-version')).strip).to eq('5.2.3')
    end

    it 'overwrites when overwrite arg is given' do
      File.write(File.join(tmp_dir, '.bootstrap-version'), "5.2.3\n")

      output = run_task('bootstrap:init', 'overwrite', tmp_dir)

      expect(output).to include('created')
      expect(File.read(File.join(tmp_dir, '.bootstrap-version')).strip).to eq('5.3.8')
    end

    it 'creates with a constrained version' do
      output = run_task('bootstrap:init', '4', tmp_dir)

      expect(output).to include('4.6.2')
      expect(File.read(File.join(tmp_dir, '.bootstrap-version')).strip).to eq('4.6.2')
    end
  end

  describe 'bootstrap:uninstall' do
    it 'deletes installed files and .bootstrap-version' do
      File.write(File.join(tmp_dir, '.bootstrap-version'), "5.3.8\n")
      css_dir = File.join(tmp_dir, 'vendor/stylesheets')
      FileUtils.mkdir_p(css_dir)
      File.write(File.join(css_dir, 'bootstrap.css'), 'body {}')

      output = run_task('bootstrap:uninstall', tmp_dir)

      expect(output).to include('Deleted')
      expect(output).to include('uninstalled')
      expect(File.exist?(File.join(css_dir, 'bootstrap.css'))).to be false
      expect(File.exist?(File.join(tmp_dir, '.bootstrap-version'))).to be false
    end

    it 'prints message when nothing to uninstall' do
      output = run_task('bootstrap:uninstall', tmp_dir)

      expect(output).to include('Nothing to uninstall')
    end
  end
end
