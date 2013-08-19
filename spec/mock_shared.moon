

-- get
-- get_stale
-- set
-- safe_set
-- add
-- safe_add
-- replace
-- incr
-- delete
-- flush_all
-- flush_expired
class Dict
  new: =>
    @flush_all!

  get: (key) =>
    @store[key], @flags[key]

  set: (key, value, exp, flags) =>
    @store[key] = value
    @flags[key] = flags
    true

  add: (key, ...) =>
    if @store[key] == nil
      @set key, ...
    true

  replace: (key, ...) =>
    if @store[key] != nil
      @set key, ...
    true

  delete: =>

  incr: (key, value) =>
    if @store[key] == nil
      return nil, "not found"

    new_val = @store[key] + value
    @store[key] = new_val
    new_val

  flush_all: =>
    @store = {}
    @flags = {}

setup = ->
  export ngx = {
    shared: setmetatable {}, __index: (key) =>
      with d = Dict!
        @[key] = d
  }

teardown = ->
  export ngx = nil

{ :setup, :teardown }
