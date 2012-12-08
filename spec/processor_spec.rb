require 'rspec'
require_relative '../src/processor'

describe Processor do
  before :all do
    @processor = Processor.new
    @processor.add_command(:hello, lambda { |t| "Hello #{t.join(" ")}".strip })
  end

  # Calling commands
  it 'should process the hello command without arguments' do
    @processor.process("hello").should == "Hello"
  end

  it 'should process the hello command with arguments' do
    @processor.process("hello world!").should == "Hello world!"
  end

  it 'should raise an error upon calling an unknown command' do
    expect { @processor.process("hey") }.to raise_error RuntimeError
  end

  # Modifying available commands
  it 'can add commands' do
    expect { @processor.process("hey") }.to raise_error RuntimeError

    @processor.add_command(:hey, lambda { |t| "Hey #{t.join(" ")}".strip })

    expect { @processor.process("hey") }.to_not raise_error RuntimeError
    @processor.process("hey world!").should == "Hey world!"
  end

  it 'can add aliases' do
    expect { @processor.process("h") }.to raise_error RuntimeError

    @processor.add_alias(:h, :hey)

    expect { @processor.process("h") }.to_not raise_error RuntimeError
    @processor.process("h world!").should == "Hey world!"
    expect { @processor.process("hey") }.to_not raise_error RuntimeError
    @processor.process("hey world!").should == "Hey world!"
  end

  it 'can remove commands' do
    expect { @processor.process("hey") }.to_not raise_error RuntimeError
    @processor.remove_command(:hey)
    expect { @processor.process("hey") }.to raise_error RuntimeError
  end

  it 'can remove aliases' do
    expect { @processor.process("h") }.to_not raise_error RuntimeError
    @processor.remove_alias(:h)
    expect { @processor.process("h") }.to raise_error RuntimeError
  end
end
