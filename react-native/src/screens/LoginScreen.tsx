import * as React from 'react';
import {
  StyleSheet,
  View,
} from 'react-native';
import {
  loginWithSSO,
  logout,
} from '@aag-development/react-native-metaone-wallet-sdk';
import { sampleSSOLogin } from '../api/ApiService';
import { useToast } from 'react-native-toast-notifications';

import { useAppContext } from '../hooks/useApp';
import type { ColorsScheme } from '@aag-development/react-native-metaone-wallet-sdk';
import useColorsAwareObject from '../hooks/useColorsAwareObject';
import { Container } from '../components/Container';
import CustomButton from '../components/Button/CustomButton';
import Input from '../components/Input';

const LoginScreen: React.FC<any> = ({ navigation }) => {
  const toast = useToast();

  const [inputValue, setInputValue] = React.useState('');
  const [isLoading, setIsLoading] = React.useState(false);
  const { setIsAuthorized } = useAppContext();

  const handleSubmit = () => {
    setIsLoading(true);
    if (inputValue) {
      sampleSSOLogin(
        { email: inputValue, password: '123456' },
        async data => {
          try {
            loginWithSSO(data.token).then(() => {
              setIsAuthorized(true);
              toast.show('Authorized successfully', { type: 'success' });
              setIsLoading(false);
              navigation.navigate('Profile');
            });
          } catch (error) {
            setIsLoading(false);
            toast.show('Authorized successfully', { type: 'error' });
          }
        },
        () => {
          setIsLoading(false);
          toast.show('Login failed', { type: 'error' });
          logout();
        },
      );
    }
  };
  const styles = useColorsAwareObject(screenStyles);
  return (
    <Container hideBack>
      <View style={styles.wrapper}>
        <Input
          keyboardType="email-address"
          style={styles.input}
          placeholder="Enter email"
          value={inputValue}
          onChangeText={text => setInputValue(text)}
        />
        <CustomButton
          label='Submit'
          loading={isLoading}
          disabled={!inputValue}
          onPress={handleSubmit}
        />
      </View>
    </Container>
  );
};

const screenStyles = (colors: ColorsScheme) =>
  StyleSheet.create({
    spinnerContainer: {
      flex: 1,
      justifyContent: 'center',
      alignItems: 'center',
      position: 'absolute',
      zIndex: 999,
      width: '100%',
      height: '100%',
      backgroundColor: '#ffffffd1',
    },
    wrapper: {
      flex: 1,
      width: '100%',
      padding: 40,
    },
    input: {
      marginBottom: 20,
    },
  });
export default LoginScreen;
