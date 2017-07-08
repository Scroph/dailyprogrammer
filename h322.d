import std.stdio;
import std.array;
import std.conv;
import std.algorithm;
import std.file;
import std.path;
import std.socket;
import std.string;


void main(string[] args)
{
	string ip = "127.0.0.1";
	if(args.length > 1)
		ip = args[1];
	ushort port = 10000;
	if(args.length > 2)
		port = args[2].to!ushort;
	auto server = StaticServer(thisExePath.dirName, new InternetAddress(ip, port));
	writeln("Listening on ", ip, ":", port);
	server.loop();
}

enum Method {HEAD, GET};
immutable string[int] replies;
immutable string[string] mimeTypes;
immutable string[] units;

static this()
{
	replies = [
		200: "200 OK",
		400: "400 Bad Request",
		403: "403 Forbidden",
		404: "404 Not Found",
		405: "405 Method Not Allowed",
		500: "500 Internal Server Error"
	];
	mimeTypes = [
		".txt": "text/plain",
		".html": "text/html",
		".mp4": "video/mp4",
		".jpg": "image/jpeg",
		".png": "image/png",
		".d": "text/most-complete-language-in-the-world",
		".bmp": "image/bmp",
		".py": "text/python",
		".php": "text/php",
		".json": "application/json",
		".xml": "application/xml",
	];
	units = ["bytes", "kB", "MB", "GB", "TB", "ZB", "NB", "FB", "Twitter", "I'm really just coming up with units at this point"];
}

class HttpException : Exception
{
	int code;
	this(int code)
	{
		this.code = code;
		super(replies[code]);
	}

	this(int code, string msg)
	{
		this.code = code;
		super(msg);
	}
}

struct StaticServer
{
	Socket sock;
	string root;

	this(string root, InternetAddress addr)
	{
		this.root = root;
		sock = new TcpSocket();
		sock.bind(addr);
		sock.listen(5);
	}

	void loop()
	{
		while(true)
		{
			auto client = sock.accept();
			writeln("Client connected from ", client.remoteAddress);
			ubyte[1024 * 1024] raw; //how large can a GET request get amirite
			auto length = client.receive(raw);
			if(length == Socket.ERROR)
			{
				writeln("Failed to receive request : ", client.getErrorText);
				continue;
			}
			if(length == 0)
			{
				writeln("Client disconnected.");
				continue;
			}
			writeln("Request received");
			try
			{
				auto req = HttpRequest(cast(string) raw[0 .. length]);
				writeln("Request parsed :");
				writeln(cast(string) raw);
				serve(client, intercept(req));
			}
			catch(HttpException e)
			{
				Appender!string contents;
				contents ~=  "<html><head><title>";
				contents ~= replies[e.code];
				contents ~= "</title></head>";
				contents ~= "<body><p>" ~ e.msg ~ "</p></body></html>";
				serve(client, HttpResponse(e.code, contents.data.representation));
			}
		}
	}

	HttpResponse intercept(HttpRequest req)
	{
		try
		{
			writeln("Method detected : ", req.method.to!string);
			auto file = buildPath(root, req.path);
			if(!file.exists)
				throw new HttpException(404, req.path ~ " was not found on this server.");
			if(file.canFind(".."))
				throw new HttpException(400, "Malformed path : " ~ file);

			if(file.isDir)
			{
				immutable(ubyte)[] html;
				try
				{
					html = file.listDirectory(root).representation;
				}
				catch(Exception e)
				{
					throw new HttpException(403, "Failed to read " ~ file);
				}
				writeln(cast(string) html);
				auto resp = HttpResponse(200, req.method == Method.GET ? html : "".representation);
				resp.setHeader("Content-Type", "text/html");
				resp.setHeader("Content-Length", html.length);
				return resp;
			}

			auto resp = HttpResponse(200, req.method == Method.GET ? cast(immutable(ubyte)[]) std.file.read(file) : "".representation);
			resp.setHeader("Content-Type", file.getContentType);
			resp.setHeader("Content-Length", file.getSize);
			writeln("Response ready !");
			return resp;
		}
		catch(HttpException e)
		{
			Appender!string contents;
			contents ~=  "<html><head><title>";
			contents ~= replies[e.code];
			contents ~= "</title></head>";
			contents ~= "<body><p>" ~ e.msg ~ "</p></body></html>";
			return HttpResponse(e.code, contents.data.representation);
		}
		catch(FileException e)
		{
			Appender!string contents;
			contents ~=  "<html><head><title>";
			contents ~= replies[403];
			contents ~= "</title></head>";
			contents ~= "<body><p>Failed to access " ~ req.path ~ " : Permission Denied</p></body></html>";
			return HttpResponse(403, contents.data.representation);
		}
		catch(Exception e)
		{
			writeln("Fatal error : ", e.msg);
			writeln(e.info);
			return HttpResponse(500, replies[500].representation);
		}
	}

	void serve(Socket client, HttpResponse resp)
	{
		client.send(resp.getHeaderText);
		string type = resp.getHeader("Content-Type", "invalid");
		if(type != "invalid" && type.startsWith("text"))
			client.send(cast(string) resp.getBody);
		else
			client.send(resp.getBody);
		client.shutdown(SocketShutdown.BOTH);
		client.close();
		writeln("Response sent.");
	}

	~this()
	{
		sock.shutdown(SocketShutdown.BOTH);
		sock.close();
		writeln("Server closed.");
	}
}

struct HttpRequest
{
	Method method;
	string path;
	string[string] headers;
	string[string] params;

	this(string raw)
	{
		auto lines = raw.splitter("\r\n");
		parseRequestLine(lines.front);
		lines.popFront;
		
		foreach(line; lines)
		{
			if(!line.strip.length)
				break;
			auto colon = line.indexOf(":");
			headers[line[0 .. colon]] = line[colon + 2 .. $];
		}
	}

	//please don't read the source code of this method
	void parseRequestLine(string line)
	{
		auto parts = line.splitter(" ");
		try
		{
			this.method = parts.front.to!Method;
		}
		catch(ConvException e)
		{
			throw new HttpException(405, parts.front ~ " is not allowed.");
		}
		parts.popFront;

		string path = parts.front.chompPrefix("/");
		auto qs_start = path.indexOf("?");
		if(qs_start != -1)
		{
			this.path = path[0 .. qs_start];
			foreach(pair; path[qs_start + 1 .. $].splitter('&'))
			{
				auto eq = pair.indexOf("=");
				params[pair[0 .. eq]] = pair[eq + 1 .. $];
			}
		}
		else
		{
			this.path = path;
		}
	}
}

struct HttpResponse
{
	string[string] headers;
	string status;
	immutable(ubyte)[] contents;

	this(uint code, immutable(ubyte)[] contents)
	{
		this.contents = contents;
		status = "HTTP/1.0 " ~ replies[code];
	}

	void setHeader(T)(string key, T val)
	{
		headers[key] = val.to!string;
	}

	string getHeader(string key, string sentinel = null)
	{
		return headers.get(key, sentinel);
	}

	string getHeaderText()
	{
		Appender!string response;
		response ~= status ~ "\r\n";
		foreach(k, v; headers)
			response ~= k ~ ": " ~ v ~ "\r\n";
		response ~= "\r\n";
		return response.data;
	}

	immutable(ubyte)[] getBody()
	{
		return contents;
	}
}

//helpers
string listDirectory(string path, string root)
{
	Appender!string html;
	html ~= "<html><head><title>Contents of " ~ path ~ "</title>";
	html ~= "<body><table>";
	html ~= "<thead>";
	html ~= "<th>Entry</th><th>Size</th><th>Type</th>";
	html ~= "</thead>";
	html ~= "<tbody>";
	if(path != root)
	{
		string current = path.chompPrefix(root);
		string parent = current.count("/") == 1 ? "/" : current[0 .. current.lastIndexOf("/")];
		html ~= "<tr>";
		html ~= `<td><a href = "` ~ parent ~ `">../</a></td>`;
		html ~= `<td> - </td>`;
		html ~= "<td> - </td>";
		html ~= "</tr>";
	}
	foreach(DirEntry e; dirEntries(path, SpanMode.shallow))
	{
		html ~= "<tr>";
		html ~= `<td><a href = "` ~ e.name.chompPrefix(root) ~ `">` ~ e.name.baseName ~ `</a></td>`;
		html ~= `<td>` ~ e.size.humanReadable ~ `</td>`;
		if(e.isDir)
			html ~= "<td>Directory</td>";
		else
			html ~= "<td>" ~ e.name.getContentType  ~ "</td>";
		html ~= "</tr>";
	}
	html ~= "</tbody>";
	html ~= "</table></body></html>";
	return html.data;
}

string getContentType(string filename)
{
	return mimeTypes.get(filename.extension, "application/octet-stream");
}

string humanReadable(ulong size)
{
	foreach(i; 0 .. units.length)
		if(size < 1024 ^^ (i + 1))
			return "%.2f %s".format(cast(float)(size) / (1024 ^^ (i + 1)), units[i]);
	return size.to!string ~ " bytes";
}
