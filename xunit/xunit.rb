require_relative 'reporter'
require_relative 'assertions'

class XUnitRunner

  def run_all_tests(test_suite)
    ResultSuite.new (
         test_suite.instance_methods
        .select {|method|      self.method_is_test method}
        .collect{|test_method| self.run_test(test_suite, test_method)}
    )
  end
  
  def run_test(test_case_definition, sym)
    test_case = test_case_definition.new.extend(Assertions)
    begin
      invoke_if_exists(test_case,:before)
      test_case.send sym
      invoke_if_exists(test_case,:after)
    rescue AssertionException => e
      return ResultFailure.new sym, e
    rescue Exception => e
      return ResultError.new sym, e
    end
    ResultSuccess.new sym
  end
  
  def invoke_if_exists(object, message)
    if object.respond_to? message
      object.send message
    end
  end

  def method_is_test(method)
    method.to_s.start_with? 'test_'
  end
  
  def run_all_and_report(test_suite)
    ConsoleReporter.new.run_and_report {
      self.run_all_tests test_suite
    }
  end

end

class AssertionException < Exception
end

class ResultSuite
  attr_accessor :results

  def initialize(results)
    self.results = results
  end

  def erred_tests
    get_signatures_for :error?
  end

  def failed_tests
    get_signatures_for :failure?
  end

  def successful_tests
    get_signatures_for :success?
  end

  def get_signatures_for(status)
    self.results.select {|result|result.send(status)}.collect { |result| result.signature }
  end

  def all_passed?
    self.failed_tests.empty? and self.erred_tests.empty?
  end
end

class Result

  attr_accessor :exception, :signature

  def initialize(signature, exception=nil)
    self.exception = exception
    self.signature = signature
  end

  def failure?
    false
  end

  def success?
    false
  end

  def error?
    false
  end

  def report
  end
end

class ResultSuccess < Result
  def success?
    true
  end

end

class ResultFailure < Result

  def failure?
    true
  end

  def report
    puts "Failure on test #{self.signature}: #{self.exception.message}".colorize(:color => :light_yellow, :background => :black)
  end
end

class ResultError < Result
  def error?
    true
  end

  def report
    puts "Error on test #{self.signature}: #{self.exception.message}".colorize(:color => :red, :background => :black)
    puts self.exception.backtrace.join("\n").colorize(:color => :red, :background => :black)
    puts "\n"
  end
end

