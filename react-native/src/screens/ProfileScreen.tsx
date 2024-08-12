import * as React from 'react';
import { StyleSheet, View, Text, Button } from 'react-native';
import {
  isSignatureSet,
  getExpireAt,
  getSessionActivityStatus,
  logout,
  refreshSession,
  setupUserData,
  AuthApiModel,
} from '@aag-development/react-native-metaone-wallet-sdk';
import { OpenWalletButton } from '../components/Button/OpenWalletButton';
import type {
  ColorsScheme,
} from '@aag-development/react-native-metaone-wallet-sdk';
import { useToast } from 'react-native-toast-notifications';
import useSessionExpiration from '../hooks/useSessionExpiration';
import { useAppContext } from '../hooks/useApp';
import useColorsAwareObject from '../hooks/useColorsAwareObject';
import { Container } from '../components/Container';
import { useAppNavigation } from '../AppNavigator';

const ProfileScreen: React.FC = () => {
  const toast = useToast();
  const [activityStatus, setActivityStatus] =
    React.useState<AuthApiModel.SessionActivityStatus>();
  const { setIsAuthorized, setGlobalLoading } = useAppContext();

  const handleRefresh = async () => {
    setGlobalLoading(true);
    await refreshSession().then(active => {
      if (active) {
        return getExpireAt().then(async (res) => {
          setExpireAt(+res);
          await setupUserData()
        });
      }
      toast.show('Session refresh was unsuccessful.', { type: 'error' });
      setGlobalLoading(false);
      logout();
    }).catch(e => {
      toast.show('Session refresh was unsuccessful.', { type: 'error' });
      setIsAuthorized(false);
      logout();
    });
    toast.show('Session refreshed.', { type: 'success' });
    setGlobalLoading(false);
  };
  const { expireAtSeconds, setExpireAt } = useSessionExpiration(toast);

  React.useEffect(() => {
    getExpireAt().then(res => {
      setExpireAt(+res);
    });
    getSessionActivityStatus().then(async (res) => {
      setActivityStatus(res);
      if (res != AuthApiModel.SessionActivityStatus.UNAUTHORISED) {
        await setupUserData()
      }
    });
  }, [setExpireAt]);

  const handleLogout = () => {
    logout();
    setIsAuthorized(false);
    toast.show('Logout successfully', { type: 'success' });
  };
  const { navigate } = useAppNavigation();

  const handleApiTesting = () => {
    navigate('ApiTesting');
  };
  const handleChangeTheme = () => {
    navigate('ChangeTheme');
  };
  const handleChangeLanguage = () => {
    navigate('ChangeLanguage');
  };

  const handlSendCustomTransaction = () => {
    isSignatureSet().then(setPin => {
      if (setPin) {
        navigate('SendCustomTransactionScreen');
      } else {
        toast.show('Please create your signature', { type: 'warning' });
      }
    });
  }

  const styles = useColorsAwareObject(screenStyles);
  return (
    <Container hideBack>
      <View style={styles.head}>
        <Text style={styles.text}>Expires at: {expireAtSeconds} </Text>
        <Text style={styles.text}>Result: {activityStatus}</Text>
      </View>
      <View style={styles.wrapper}>
        <OpenWalletButton
          title="OPEN WALLET ACTIVITY"
          disabled={activityStatus === 'UNAUTHORISED'}
        />
        <Button onPress={handlSendCustomTransaction} title="SEND CUSTOM TRANSACTION" />
        <Button onPress={handleApiTesting} title="API TESTING" />
        <Button onPress={handleRefresh} title="REFRESH SESSION" />
        <Button onPress={handleChangeTheme} title="CHANGE THEME" />
        <Button onPress={handleChangeLanguage} title="CHANGE LANGUAGE" />
        <Button onPress={handleLogout} title="LOGOUT" />
      </View>
    </Container>
  );
};

const screenStyles = (colors: ColorsScheme) =>
  StyleSheet.create({
    text: {
      color: colors.black,
    },
    head: {
      width: '100%',
      padding: 40,
    },
    wrapper: {
      flex: 1,
      width: '100%',
      gap: 15,
    },
  });

export default ProfileScreen;
