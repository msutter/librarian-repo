require 'spec_helper'

require 'tmpdir'

describe "Functional - Install" do
  before :all do
    warning_message = "ATTENTION: these tests download information from github.com"
    puts "\n"
    puts '*' * warning_message.length
    puts warning_message
    puts '*' * warning_message.length
  end

  it "displays install help message" do
    output, status = execute_captured("bin/librarian-repo help install")
    output.should_not include("ERROR")
    output.should_not include("Could not find command")
    status.should == 0
  end

  describe "when running 'librarian-repo install'" do
    temp_directory = nil

    before :each do
      temp_directory = Dir.mktmpdir
      Dir.entries(temp_directory).should =~ ['.', '..']
      FileUtils.touch File.join(temp_directory, 'trashfile')
      Dir.entries(temp_directory).should =~ ['.', '..', 'trashfile']
    end

    after :each do
      FileUtils.rm_rf temp_directory
    end

    it "install the repos in a temp directory" do
      output, status = execute_captured("bin/librarian-repo install --path=#{temp_directory} --Repofile=spec/fixtures/Repofile")

      status.should == 0
      Dir.entries(temp_directory).should =~ %w|. .. apache ntp trashfile dnsclient testlps|
    end

    it "with --clean it cleans the directory before installing the repos in a temp directory" do
      output, status = execute_captured("bin/librarian-repo install --clean --path=#{temp_directory} --Repofile=spec/fixtures/Repofile")

      status.should == 0
      Dir.entries(temp_directory).should =~ %w|. .. apache ntp dnsclient testlps|
    end

    it "with --verbose it outputs progress messages" do
      output, status = execute_captured("bin/librarian-repo install --verbose --path=#{temp_directory} --Repofile=spec/fixtures/Repofile")

      status.should == 0
      output.should include('##### processing module apache')
    end

    describe 'when repos are already installed' do
      temp_directory = nil

      before :each do
        temp_directory = Dir.mktmpdir
        Dir.entries(temp_directory).should =~ ['.', '..']
        FileUtils.touch File.join(temp_directory, 'apache')
        Dir.entries(temp_directory).should =~ ['.', '..', 'apache']
      end

      it 'without clean it should only install ntp' do
        output, status = execute_captured("bin/librarian-repo install --verbose --path=#{temp_directory} --Repofile=spec/fixtures/Repofile")
        status.should == 0
        output.should include('Module apache already installed')
        Dir.entries(temp_directory).should =~ %w|. .. apache ntp dnsclient testlps|
      end
    end
  end

end
