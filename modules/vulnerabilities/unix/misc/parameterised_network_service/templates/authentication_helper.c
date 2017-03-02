bool login()
{
	bool authenticated = false;
	char password[15];

	printf("\n Please enter the password : \n");
    gets(password);	

    if(strcmp(password, "secureAdminPwd"))
    {
        printf ("\n Wrong Password \n");
    }
    else
    {
        printf ("\n Correct Password \n");
        authenticated = true;
    }
	
	return authenticated;
}
