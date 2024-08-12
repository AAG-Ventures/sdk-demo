import React from 'react';
import ProfileScreen from './screens/ProfileScreen';
import LoginScreen from './screens/LoginScreen';
import {NavigationContainer, useNavigation} from '@react-navigation/native';
import {
  createNativeStackNavigator,
  type NativeStackNavigationProp,
} from '@react-navigation/native-stack';
import {ActivityIndicator, StyleSheet, View} from 'react-native';
import {useAppContext} from './hooks/useApp';
import ChangeThemeScreen from './screens/ChangeThemeScreen';
import ChangeLanguageScreen from './screens/ChangeLanguageScreen';
import ApiTestingScreen from './screens/ApiTestingScreen';
import SendCustomTransactionScreen from './screens/SendCustomTransactionScreen';

export type RouteStackTypescript = {
  Login: undefined;
  Profile: undefined;
  ChangeTheme: undefined;
  ChangeLanguage: undefined;
  ApiTesting: undefined;
  SendCustomTransactionScreen: undefined;
};

export const useAppNavigation = () =>
  useNavigation<NativeStackNavigationProp<RouteStackTypescript>>();

const Stack = createNativeStackNavigator<RouteStackTypescript>();

const AppNavigator: React.FC = () => {
  const {isInitialized, isAuthorized, isGlobalLoading} = useAppContext();
  return (
    <View style={styles.container}>
      {isInitialized && (
        <NavigationContainer>
          <Stack.Navigator>
            {!isAuthorized ? (
              <Stack.Group>
                <Stack.Screen
                  name="Login"
                  component={LoginScreen}
                  options={{headerShown: false}}
                />
              </Stack.Group>
            ) : (
              <Stack.Group>
                <Stack.Screen
                  name="Profile"
                  component={ProfileScreen}
                  options={{headerShown: false}}
                />
                <Stack.Screen
                  name="ChangeTheme"
                  component={ChangeThemeScreen}
                  options={{headerShown: false}}
                />
                <Stack.Screen
                  name="ChangeLanguage"
                  component={ChangeLanguageScreen}
                  options={{headerShown: false}}
                />
                <Stack.Screen
                  name="ApiTesting"
                  component={ApiTestingScreen}
                  options={{headerShown: false}}
                />
                 <Stack.Screen
                  name="SendCustomTransactionScreen"
                  component={SendCustomTransactionScreen}
                  options={{headerShown: false}}
                />
              </Stack.Group>
            )}
          </Stack.Navigator>
        </NavigationContainer>
      )}
      {isGlobalLoading && (
        <View style={styles.spinnerContainer}>
          <ActivityIndicator size="large" color="black" />
        </View>
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  spinnerContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    zIndex: 999,
    position: 'absolute',
    width: '100%',
    height: '100%',
    backgroundColor: '#ffffff50',
  },
});

export default AppNavigator;
