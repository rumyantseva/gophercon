package routing_test

import (
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/rumyantseva/gophercon/pkg/routing"
)

func TestDiagnosticsRouter_ShouldReturn_StatusOK_whenHitting_HealthzEndpoint(t *testing.T) {
	handler := routing.DiagnosticsRouter()

	ts := httptest.NewServer(handler)
	defer ts.Close()

	res, err := http.Get(ts.URL + "/healthz")
	if err != nil {
		t.Fatal(err)
	}

	// todo: you can use testify library instead
	expectedStatusCode := http.StatusOK
	if res.StatusCode != http.StatusOK {
		t.Errorf("Want %d, got %d", expectedStatusCode, res.StatusCode)
	}
}

func TestDiagnosticsRouter_ShouldReturn_StatusOK_whenHitting_ReadyzEndpoint(t *testing.T) {
	handler := routing.DiagnosticsRouter()

	ts := httptest.NewServer(handler)
	defer ts.Close()

	res, err := http.Get(ts.URL + "/readyz")
	if err != nil {
		t.Fatal(err)
	}

	// todo: you can use testify library instead
	expectedStatusCode := http.StatusOK
	if res.StatusCode != http.StatusOK {
		t.Errorf("Want %d, got %d", expectedStatusCode, res.StatusCode)
	}
}
