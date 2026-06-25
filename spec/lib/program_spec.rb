# frozen_string_literal: true

require './lib/program'

RSpec.describe Program do
  subject(:execute) { described_class.new.execute(argv) }

  let(:argv) { [] }

  describe '#execute' do
    context 'when no arguments are given' do
      it 'returns exit code 1' do
        expect(execute.exit_code).to eq(1)
      end

      it 'has the "No command given" description' do
        expect(execute.exit_description).to eq('No command given')
      end
    end

    context 'when the command is unknown' do
      let(:argv) { %w[see rails] }

      it 'returns exit code 2' do
        expect(execute.exit_code).to eq(2)
      end

      it 'has the "Command unknown" description' do
        expect(execute.exit_description).to eq('Command unknown')
      end
    end

    context 'when the command raises a CLIError' do
      let(:command) { instance_double(Command) }
      let(:argv) { %w[show] }

      before do
        allow(CommandFactory).to receive(:find).with('show').and_return(command)
        allow(command).to receive(:execute).with([]).and_raise(MissingGemNameError)
      end

      it 'translates it into a ProgramResult with the error exit code' do
        expect(execute.exit_code).to eq(3)
      end

      it 'translates it into a ProgramResult with the error message' do
        expect(execute.exit_description).to eq('No gem name given')
      end
    end

    context 'when the command raises GemNotFoundError' do
      let(:command) { instance_double(Command) }
      let(:argv) { %w[show nope] }

      before do
        allow(CommandFactory).to receive(:find).with('show').and_return(command)
        allow(command).to receive(:execute).with(['nope']).and_raise(GemNotFoundError)
      end

      it 'returns exit code 4' do
        expect(execute.exit_code).to eq(4)
      end
    end

    context 'when the command returns a result' do
      let(:command) { instance_double(Command) }
      let(:argv) { %w[show rails] }

      before do
        allow(CommandFactory).to receive(:find).with('show').and_return(command)
        allow(command).to receive(:execute).with(['rails']).and_return(ProgramResult.new(0, 'ok'))
      end

      it 'returns the command result unchanged' do
        expect(execute.exit_code).to eq(0)
      end

      it 'preserves the command description' do
        expect(execute.exit_description).to eq('ok')
      end
    end

    context 'when extra args are present' do
      let(:command) { instance_double(Command) }
      let(:argv) { %w[search rspec --license MIT] }

      before do
        allow(CommandFactory).to receive(:find).with('search').and_return(command)
        allow(command).to receive(:execute)
          .with(['rspec', '--license', 'MIT'])
          .and_return(ProgramResult.new(0, 'ok'))
      end

      it 'passes the full slice through to the command' do
        expect(execute.exit_code).to eq(0)
      end
    end
  end
end
