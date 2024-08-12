import axios from 'axios';

type RequestType = {
  email: string;
  password: string;
};

type ResponseType = {
  token: string;
};

export const sampleSSOLogin = (
  request: RequestType,
  onSuccess: (data: ResponseType) => void,
  onFailure: (error: any) => void,
): void => {
  const url = 'https://ws-test.aag.ventures/sso/login';
  axios
    .post<ResponseType>(url, request, {
      headers: {
        'Content-Type': 'application/json',
      },
    })
    .then(response => {
      onSuccess(response.data);
    })
    .catch(error => {
      if (error.response) {
        console.log(error.response.data);
        console.log(error.response.status);
        console.log(error.response.headers);
      } else if (error.request) {
        console.log(error.request);
        console.log(error);
      } else {
        console.log('Error', error.message);
        console.log('Error', error);
      }
      console.log(error.config);
      onFailure(error);
    });
};
