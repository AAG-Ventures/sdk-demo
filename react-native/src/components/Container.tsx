import React, {type ReactNode} from 'react';
import {Button, SafeAreaView, StyleSheet} from 'react-native';
import type {ColorsScheme} from '@aag-development/react-native-metaone-wallet-sdk';
import useColorsAwareObject from '../hooks/useColorsAwareObject';
import {useNavigation} from '@react-navigation/native';

interface IContainer {
  children: ReactNode;
  hideBack?: boolean;
}
export const Container = ({children, hideBack = false}: IContainer) => {
  const styles = useColorsAwareObject(screenStyles);
  const {goBack} = useNavigation();
  return (
    <SafeAreaView style={styles.container}>
      {!hideBack && <Button onPress={goBack} title="GO BACK" />}
      {children}
    </SafeAreaView>
  );
};
const screenStyles = (colors: ColorsScheme) =>
  StyleSheet.create({
    container: {
      flex: 1,
      alignItems: 'center',
      justifyContent: 'center',
      padding: 20,
      backgroundColor: colors.background,
    },
  });
