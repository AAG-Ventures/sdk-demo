import React from 'react';
import {ToastProvider} from 'react-native-toast-notifications';
import AppNavigator from './AppNavigator';
import {AppProvider} from './hooks/useApp';

const App: React.FC = () => {
  return (
    <AppProvider>
      <ToastProvider
        placement="bottom"
        duration={4000}
        animationType="slide-in"
        offsetBottom={40}>
        <AppNavigator />
      </ToastProvider>
    </AppProvider>
  );
};

export default App;
