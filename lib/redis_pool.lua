local redis = require 'resty.redis'

-- Redis connection parameters
local _M = {
  host      = os.getenv("REDIS_HOST") or 'xc-redis',
  port      = 6379,
  timeout   = 1000,  -- 1 second
  keepalive = 10000, -- milliseconds
  poolsize  = 1000   -- # connections
}

-- @return table with a redis connection from the pool
function _M.acquire()
  local conn = redis:new()

  conn:set_timeout(_M.timeout)

  local ok, err = conn:connect(_M.host, _M.port)

  return conn, ok, err
end

-- return ownership of this connection to the pool
function _M.release(conn)
  conn:set_keepalive(_M.keepalive, _M.poolsize)
end

return _M