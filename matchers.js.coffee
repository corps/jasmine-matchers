beforeEach ->
  this.addMatchers
    toBeCloseTo: (expected, variance) ->
      @actual >= expected * (1 - variance) && @actual <= expected * (1 + variance)

    toHaveCalled: (spy, method=null) ->
      if method? and typeof method == "string" and not spy[method].callCount?
        spyOn(spy, method)
        spy = spy[method]

      @message = ->
        [ "Expected " + jasmine.pp(spy) + " to have been called",
          "Expected " + jasmine.pp(spy) + " not to have been called" ]
      count = spy.callCount
      @actual.apply(jasmine.getEnv().currentSpec)
      spy.callCount > count

    toHaveCalledWith: (spy, method=null) ->
      args = Array.prototype.slice.apply(arguments, [1])
      if method? and typeof method == "string" and not spy.callCount?
        if not spy[method].callCount?
          spyOn(spy, method)
        spy = spy[method]
        args = Array.prototype.slice.apply(arguments, [2])

      unless spy.callCount?
        throw "Must provide a spy!"

      count = spy.callCount
      @actual.apply(jasmine.getEnv().currentSpec)
      @message = ->
        if spy.mostRecentCall && spy.callCount > count
          [ "Expected " + jasmine.pp(spy) + " to have been called with " + jasmine.pp(args) + " but received " + jasmine.pp(spy.mostRecentCall.args),
            "Expected " + jasmine.pp(spy) + " not to have been called with " + jasmine.pp(args) + " but it did receive " + jasmine.pp(spy.mostRecentCall.args) ]
        else
          [ "Expected " + jasmine.pp(spy) + " to have been called",
            "Expected " + jasmine.pp(spy) + " not to have been called" ]

      spy.callCount > count && _.all(_.zip(spy.mostRecentCall.args, args), (v) => @env.equals_(v[0], v[1]))

    toRaiseAnError: () ->
      try
        @actual.apply(jasmine.getEnv().currentSpec)
      catch e
        return true
      @message = -> "Expected function " + jasmine.pp(@actual) + " to raise error, but it did not"
      return false

    toChange: (base, attr=null, to=null) ->
      unless typeof base == "function"
        f = -> base[attr]
      else
        f = base
        to = attr
      wrappedF = -> f.apply(jasmine.getEnv().currentSpec)

      previous = wrappedF()
      @actual.apply(jasmine.getEnv().currentSpec)
      val = wrappedF()

      @message = ->
        if to?
          [ "Expected value " + jasmine.pp(previous) + " to have changed to " + jasmine.pp(to) + " but it is " + jasmine.pp(val),
            "Expected value " + jasmine.pp(previous) + " not to have changed to " + jasmine.pp(to) + " but it is " + jasmine.pp(val) ]
        else
          [ "Expected value " + jasmine.pp(previous) + " to have changed",
            "Expected value " + jasmine.pp(previous) + " not to have changed but now it is " + jasmine.pp(val)]

      return false unless !@env.equals_(val, previous)
      return true unless to? && !@env.equals_(to, val)
