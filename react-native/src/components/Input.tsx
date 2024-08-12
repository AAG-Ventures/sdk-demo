import * as React from 'react';
import { StyleSheet, TextInput, TextInputProps } from "react-native"
import type { ColorsScheme } from '@aag-development/react-native-metaone-wallet-sdk';
import useColorsAwareObject from '../hooks/useColorsAwareObject';
import { useAppContext } from '../hooks/useApp';


const Input: React.FC<TextInputProps> = ({ style, ...props }) => {
    const { colors } = useAppContext();
    const styles = useColorsAwareObject(screenStyles);
    return (
        <TextInput
            placeholderTextColor={colors?.black80}
            {...props}
            style={[styles.input, style]}
        />
    )
}


const screenStyles = (colors: ColorsScheme) =>
    StyleSheet.create({
        input: {
            color: colors.black,
            padding: 10,
            borderWidth: 1,
            marginBottom: 5,
            borderRadius: 4,
            borderColor: colors.black60,
        },
    });


export default Input