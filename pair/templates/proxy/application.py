# Example proxy server for Pair

from services import ProxyService

proxy_service = ProxyService()

services = {
    'eu.collab.pair.services': proxy_service,
}

# Gateway
from pyamf.remoting.gateway.wsgi import WSGIGateway

application = WSGIGateway(services, expose_environ=True)

# Development server
from wsgiref import simple_server

host = 'localhost'
port = 8000

httpd = simple_server.WSGIServer(
        (host, port),
        simple_server.WSGIRequestHandler,
    )

httpd.set_app(application)

print "Started Pair - Proxy Server on http://%s:%d" % (host, port)

try:
    httpd.serve_forever()
except KeyboardInterrupt:
    pass
