# Go HTTP Server

Simple HTTP server.

## Instructions

1. Run the server:

   ```sh
   go run main.go
   ```

### `/api/health`

1. Open <http://localhost:9000/api/health> in a browser or use `curl`:

   ```sh
   $ curl http://localhost:9000/api/health
   {"ok":true}
   ```

### `/mp3`

1. Add the music file to `files`:

   ```sh
   mkdir files && \
   curl --location https://freemusicarchive.org/track/Marsel_Minga_-_01_-_Demonstration/download \
   --output files/Marsel_Minga_-_01_-_Demonstration.mp3
   ```

1. Open <http://localhost:9000/mp3> in a browser or use `curl`:

   ```sh
   curl http://localhost:9000/mp3 --output Marsel_Minga_-_01_-_Demonstration.mp3
   ```
