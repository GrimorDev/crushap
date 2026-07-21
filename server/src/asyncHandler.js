// Express 4 does not catch rejected promises thrown from an `async`
// route handler — an unhandled exception there becomes an unhandled
// promise rejection at the process level, which (on modern Node) takes
// the whole server down instead of just failing that one request. Every
// async handler in this app is wrapped with this so a bug in one request
// returns a clean 500 instead of crashing every other in-flight request
// too.
function asyncHandler(fn) {
  return (req, res, next) => Promise.resolve(fn(req, res, next)).catch(next);
}

module.exports = { asyncHandler };
