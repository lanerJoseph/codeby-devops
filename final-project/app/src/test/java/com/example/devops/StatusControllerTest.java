package com.example.devops;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.boot.test.web.server.LocalServerPort;
import org.springframework.http.ResponseEntity;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class StatusControllerTest {

    @LocalServerPort
    private int port;

    @Autowired
    private TestRestTemplate restTemplate;

    @Test
    void rootReturnsApplicationInfo() {
        ResponseEntity<String> response = restTemplate.getForEntity(
            "http://localhost:" + port + "/", String.class);

        assertEquals(200, response.getStatusCode().value());
        assertTrue(response.getBody().contains("\"application\":\"devops-demo\""));
        assertTrue(response.getBody().contains("\"status\":\"running\""));
    }

    @Test
    void healthReturnsUp() {
        ResponseEntity<String> response = restTemplate.getForEntity(
            "http://localhost:" + port + "/health", String.class);

        assertEquals(200, response.getStatusCode().value());
        assertTrue(response.getBody().contains("\"status\":\"UP\""));
    }

    @Test
    void prometheusEndpointIsAvailable() {
        ResponseEntity<String> response = restTemplate.getForEntity(
            "http://localhost:" + port + "/actuator/prometheus", String.class);

        assertEquals(200, response.getStatusCode().value());
        assertNotNull(response.getBody());
        assertTrue(response.getBody().contains("# HELP"));
    }
}
