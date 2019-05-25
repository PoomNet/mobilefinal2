class CurrentUser {
   static var USERID;
   static var NAME;
   static var AGE;
   static var PASSWORD;
   static var USER;

   static String whoCurrent(){
     return "current -> id: ${USERID}, name: ${NAME}, age: ${AGE}, password: ${PASSWORD}, user: ${USER}";
   }
}