# PawCite

 `PawCite` is a Nim‑based CLI tool that retrieves metadata from the Crossref API using a DOI and generates a concise citation string.

 ## Features
 - Output a formatted citation by simply providing a DOI as a command‑line argument  
- Produces shortened citations like “Smith J. et al., Nat. Biotechnol. (2025)”  
- Directly calls the Crossref REST API and parses the JSON response

## Usase

```bash
 pawcite  <DOI> [<DOI> ...]
```


## Building from Source

```bash
git clone https://github.com/yuki-hada/PawCite.git
cd PawCite
nimble build
```
