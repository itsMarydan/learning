package main

import (
	"bytes"
	"crypto/tls"
	"encoding/json"
	"fmt"
	"net/http"
	"net/http/httputil"
	"net/url"
)
type TokenResponse struct {
	AccessToken      string `json:"access_token"`
	ExpiresIn        int    `json:"expires_in"`
	RefreshExpiresIn int    `json:"refresh_expires_in"`
	RefreshToken     string `json:"refresh_token"`
	TokenType        string `json:"token_type"`
	NotBeforePolicy  int    `json:"not-before-policy"`
	SessionState     string `json:"session_state"`
	Scope            string `json:"scope"`
}

func main() {
	proxy := httputil.NewSingleHostReverseProxy(&url.URL{
		Scheme: "http",
		Host: "destination.com",
	})
	//Add middleware function
	http.HandleFunc("/", middleware(proxy.ServeHTTP))

	http.ListenAndServe(":8080", nil)
}

func middleware(next http.HandlerFunc) http.HandlerFunc {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		username, password, _ := r.BasicAuth()
		//call function to retrive auth token from keycloak
		token,err := getAuthToken(username, password)
		if err == nil{
			r.Header.Add("Authorization", "Bearer "+token)
		}
		next(w, r)
	})
}

func getAuthToken(username string, password string) (string, error) {
	// your code to retrieve the auth token here
	// Set the variables
	clientId := "demo-client"
	clientSecret := "DoN1Q0SbUa8JEo0eRytfVwDtu96nW9ig"
	realm := "demo"
	keycloakUrl := "https://keycloak.centralizer.io"

	// Create the request data
	data := url.Values{}
	data.Set("username", username)
	data.Set("password", password)
	data.Set("grant_type", "password")
	data.Set("client_id", clientId)
	data.Set("client_secret", clientSecret)

	// Create the http client
	tr := &http.Transport{
		TLSClientConfig: &tls.Config{InsecureSkipVerify: true},
	}
	client := &http.Client{Transport: tr}

	// Create the request
	req, err := http.NewRequest("POST", keycloakUrl+"/realms/"+realm+"/protocol/openid-connect/token", bytes.NewBufferString(data.Encode()))
	if err != nil {
		fmt.Println(err)
		return "", nil
	}

	req.Header.Add("Content-Type", "application/x-www-form-urlencoded")

	// Send the request
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println(err)
		return "", nil
	}
	defer resp.Body.Close()

	// Parse the response
	var token TokenResponse
	json.NewDecoder(resp.Body).Decode(&token)

	fmt.Println("Access Token:", token.AccessToken)
	return token.AccessToken, nil
}
