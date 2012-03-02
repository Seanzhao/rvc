require 'test_helper'

MODULES_DIR = File.join(File.dirname(__FILE__), 'modules')

class ModulesTest < Test::Unit::TestCase
  def setup
    session = RVC::MemorySession.new
    @shell = RVC::Shell.new(session)
    @shell.cmds = RVC::Namespace.new 'root', @shell, nil
    @shell.load_module_dir MODULES_DIR, @shell.cmds, false
  end

  def teardown
    @shell = nil
  end

  def test_modules
    foo = @shell.cmds.foo
    assert_equal 42, foo.foo

    cmd = @shell.cmds[:foo]
    assert_equal @shell.cmds.foo, cmd

    cmd = @shell.lookup_cmd [:foo]
    assert_equal @shell.cmds.foo.commands[:foo], cmd

    assert_equal 13, foo.bar.bar

    ns = @shell.lookup_cmd [:foo, :bar], RVC::Namespace
    assert_equal @shell.cmds.foo.bar, ns

    cmd = @shell.lookup_cmd [:foo, :bar, :bar]
    assert_equal @shell.cmds.foo.bar.commands[:bar], cmd
    assert_equal cmd, @shell.cmds[:foo].bar.commands[:bar]
  end
end
