jasmine-matchers
================

Matchers for jasmine aimed at testing method side effects.

toHaveCalled
------------

    expect(-> obj.method()).toHaveCalled(obj, "method")
    spy = jasmine.createSpy()
    expect(-> spy()).toHaveCalled(spy)

toHaveCalledWith
----------------

    expect(-> obj.method(1, 2)).toHaveCalledWith(obj, "method", 1, 2)
    spy = jasmine.createSpy()
    expect(-> spy("b", [1, 2])).not.toHaveCalledWith(spy, "b")

toRaiseAnError
--------------

    expect(-> throw "Error!").toRaiseAnError()
    
toChange
--------

    obj = {"b": 1}
    expect(-> obj.b = 4).toChange(obj, "b")
    expect(-> obj.b = 4).toChange(obj, "b", 4)
    expect(-> obj.b = 4).toChange((-> obj.b), 4)
