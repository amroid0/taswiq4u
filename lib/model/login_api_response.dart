class LoginApiResponse<T> {
  Status status;
  T data;
  String message;

  LoginApiResponse.loading(this.message) : status = Status.LOADING;
  LoginApiResponse.authenticate(this.message) : status = Status.AUTHNTICATED;
  LoginApiResponse.unAuthenticate(this.message) : status = Status.UNAUTHINTICATED;
  LoginApiResponse.unverified(this.message) : status = Status.UNVERFIED;
  LoginApiResponse.error(this.message) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

enum Status { LOADING, AUTHNTICATED,UNVERFIED,UNAUTHINTICATED, ERROR }