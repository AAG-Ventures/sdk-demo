import * as React from 'react';
import {StyleSheet, View, Text, Button} from 'react-native';
import type {ColorsScheme} from '@aag-development/react-native-metaone-wallet-sdk';
import useColorsAwareObject from '../hooks/useColorsAwareObject';
import {Container} from '../components/Container';
import {useAppContext} from '../hooks/useApp';

const ChangeThemeScreen: React.FC = () => {
  const {onChangeTheme} = useAppContext();
  const styles = useColorsAwareObject(screenStyles);

  return (
    <Container>
      <View style={styles.head}>
        <Text style={styles.label}>Themes</Text>
      </View>
      <View style={styles.wrapper}>
        <Button onPress={() => onChangeTheme('dark')} title="DARK" />
        <Button onPress={() => onChangeTheme('light')} title="LIGHT" />
      </View>
    </Container>
  );
};

const screenStyles = (colors: ColorsScheme) =>
  StyleSheet.create({
    label: {
      fontSize: 20,
      fontWeight: '700',
      color: colors.black,
      textAlign: 'center',
    },
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

export default ChangeThemeScreen;
