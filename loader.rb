
$data = JSON.parse(STDIN.gets)

def request; Marshal.load($data["request"]); end
def site; $data["site"]; end
def params; $data["params"]; end
def file; $data["file"]; end


