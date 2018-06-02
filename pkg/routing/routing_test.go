package routing_test

import (
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/rumyantseva/gophercon/pkg/routing"
)

func TestBaseRouter_ShouldReturn_StatusOK_whenHitting_HomeEndpoint(t *testing.T) {
	handler := routing.BaseRouter()

	ts := httptest.NewServer(handler)
	defer ts.Close()

	res, err := http.Get(ts.URL + "/home")
	if err != nil {
		t.Fatal(err)
	}

	// todo: you can use testify library instead
	expectedStatusCode := http.StatusOK
	if res.StatusCode != http.StatusOK {
		t.Errorf("Want %d, got %d", expectedStatusCode, res.StatusCode)
	}
}
