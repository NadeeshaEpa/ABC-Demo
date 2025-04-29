import React from "react";
import ReactDOM from "react-dom/client";
import "./index.css";
import App from "./App";
import { AuthProvider } from "@asgardeo/auth-react";
import {
  BASE_URL,
  CLIENT_ID,
  SIGN_IN_REDIRECT_URL,
  SIGN_OUT_REDIRECT_URL,
} from "./constants";

const root = ReactDOM.createRoot(
  document.getElementById("root") as HTMLElement
);

const authConfig = {
  clientID: CLIENT_ID || "",
  baseUrl: BASE_URL || "",
  signInRedirectURL: SIGN_IN_REDIRECT_URL || "https://wso2.com",
  signOutRedirectURL: SIGN_OUT_REDIRECT_URL || "https://wso2.com",
  scope: ["openid", "profile", "email"],
};

root.render(
  <React.StrictMode>
    <AuthProvider config={authConfig}>
      <App />
    </AuthProvider>
    {/* <AuthProvider 
      config={ {
            signInRedirectURL: "https://localhost:3000",
            signOutRedirectURL: "https://localhost:3000",
            clientID: "hJ23VjeHg2mUjR7Tsx0YfsZtRAMa",
            baseUrl: "https://api.asgardeo.io/t/org1s67h",
            scope: [ "openid","profile" ]
        } }>
      <App />
    </AuthProvider> */}
  </React.StrictMode>
);
